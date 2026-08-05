// Proxies IGDB requests so the Twitch/IGDB credentials never ship in the
// client build. Supabase verifies the caller's own auth JWT before this
// function ever runs (the platform's default `verify_jwt` behaviour) --
// do not deploy with --no-verify-jwt.

const TWITCH_TOKEN_URL = "https://id.twitch.tv/oauth2/token";
const IGDB_BASE_URL = "https://api.igdb.com/v4";

// The only endpoints the app calls today. Anything else is rejected --
// this proxies QuestLoggd's own IGDB usage, not a general relay.
const ALLOWED_ENDPOINTS = new Set(["games", "release_dates"]);

const clientId = Deno.env.get("TWITCH_CLIENT_ID");
const clientSecret = Deno.env.get("TWITCH_CLIENT_SECRET");

if (!clientId || !clientSecret) {
  throw new Error(
    "TWITCH_CLIENT_ID and TWITCH_CLIENT_SECRET must be set as function secrets",
  );
}

// Cached for as long as this instance stays warm -- the same
// one-token-per-process approach the client used, moved server-side so
// IGDB rate limiting applies per-app rather than per-user.
let cachedToken: { accessToken: string; expiresAt: number } | null = null;

async function fetchTwitchToken(): Promise<string> {
  const response = await fetch(TWITCH_TOKEN_URL, {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      client_id: clientId!,
      client_secret: clientSecret!,
      grant_type: "client_credentials",
    }),
  });

  if (!response.ok) {
    throw new Error(`Twitch token request failed: ${response.status}`);
  }

  const data = await response.json() as {
    access_token: string;
    expires_in: number;
  };

  cachedToken = {
    accessToken: data.access_token,
    // 60s safety margin so a token already in flight never expires
    // mid-request.
    expiresAt: Date.now() + (data.expires_in - 60) * 1000,
  };
  return cachedToken.accessToken;
}

function getTwitchToken(): Promise<string> {
  if (cachedToken && cachedToken.expiresAt > Date.now()) {
    return Promise.resolve(cachedToken.accessToken);
  }
  return fetchTwitchToken();
}

function callIgdb(
  endpoint: string,
  query: string,
  token: string,
): Promise<Response> {
  return fetch(`${IGDB_BASE_URL}/${endpoint}`, {
    method: "POST",
    headers: {
      "Client-ID": clientId!,
      "Authorization": `Bearer ${token}`,
      "Content-Type": "text/plain",
    },
    body: query,
  });
}

function jsonError(message: string, status: number): Response {
  return new Response(JSON.stringify({ error: message }), {
    status,
    headers: { "Content-Type": "application/json" },
  });
}

export async function handler(req: Request): Promise<Response> {
  if (req.method !== "POST") {
    return jsonError("Method not allowed", 405);
  }

  let body: { endpoint?: unknown; query?: unknown };
  try {
    body = await req.json();
  } catch {
    return jsonError("Request body must be JSON", 400);
  }

  const { endpoint, query } = body;

  if (typeof endpoint !== "string" || !ALLOWED_ENDPOINTS.has(endpoint)) {
    return jsonError(
      `endpoint must be one of: ${[...ALLOWED_ENDPOINTS].join(", ")}`,
      400,
    );
  }

  if (typeof query !== "string" || query.trim().length === 0) {
    return jsonError("query must be a non-empty APICalypse string", 400);
  }

  try {
    let token = await getTwitchToken();
    let igdbResponse = await callIgdb(endpoint, query, token);

    // Mirrors the client's existing retry-once-on-401: the cached token
    // can go stale between our expiry check and IGDB's own, so refetch
    // once and retry before giving up.
    if (igdbResponse.status === 401) {
      cachedToken = null;
      token = await getTwitchToken();
      igdbResponse = await callIgdb(endpoint, query, token);
    }

    const responseBody = await igdbResponse.text();
    return new Response(responseBody, {
      status: igdbResponse.status,
      headers: { "Content-Type": "application/json" },
    });
  } catch (error) {
    console.error("igdb-proxy error:", error);
    return jsonError("Upstream IGDB request failed", 502);
  }
}

Deno.serve(handler);
