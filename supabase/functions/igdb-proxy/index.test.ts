import { handler } from "./index.ts";

function assertEquals(actual: unknown, expected: unknown): void {
  const a = JSON.stringify(actual);
  const e = JSON.stringify(expected);
  if (a !== e) {
    throw new Error(`assertEquals failed:\n  actual:   ${a}\n  expected: ${e}`);
  }
}

function withMockedFetch(
  impl: (req: Request) => Promise<Response>,
  run: () => Promise<void>,
): Promise<void> {
  const original = globalThis.fetch;
  globalThis.fetch =
    ((input: string | URL | Request, init?: RequestInit) =>
      impl(new Request(input, init))) as typeof fetch;
  return run().finally(() => {
    globalThis.fetch = original;
  });
}

function post(body: unknown): Request {
  return new Request("http://localhost/igdb-proxy", {
    method: "POST",
    body: JSON.stringify(body),
  });
}

Deno.test("forwards an allowed endpoint and returns IGDB's response", async () => {
  let sawAuthHeader: string | null = null;
  let sawClientIdHeader: string | null = null;
  let sawBody: string | null = null;

  await withMockedFetch(async (req) => {
    const url = req.url;
    if (url.startsWith("https://id.twitch.tv/")) {
      return new Response(
        JSON.stringify({ access_token: "tok-1", expires_in: 3600 }),
        { status: 200 },
      );
    }
    if (url === "https://api.igdb.com/v4/games") {
      sawAuthHeader = req.headers.get("Authorization");
      sawClientIdHeader = req.headers.get("Client-ID");
      sawBody = await req.text();
      return new Response(JSON.stringify([{ id: 1, name: "Test Game" }]), {
        status: 200,
      });
    }
    throw new Error(`unexpected fetch to ${url}`);
  }, async () => {
    const res = await handler(
      post({ endpoint: "games", query: "fields name; limit 10;" }),
    );
    assertEquals(res.status, 200);
    assertEquals(await res.json(), [{ id: 1, name: "Test Game" }]);
    assertEquals(sawAuthHeader, "Bearer tok-1");
    assertEquals(sawClientIdHeader, "test_id");
    assertEquals(sawBody, "fields name; limit 10;");
  });
});

Deno.test("rejects an endpoint outside the allow-list", async () => {
  const res = await handler(
    post({ endpoint: "characters", query: "fields name;" }),
  );
  assertEquals(res.status, 400);
});

Deno.test("rejects a missing query", async () => {
  const res = await handler(post({ endpoint: "games" }));
  assertEquals(res.status, 400);
});

Deno.test("rejects non-POST requests", async () => {
  const res = await handler(
    new Request("http://localhost/igdb-proxy", { method: "GET" }),
  );
  assertEquals(res.status, 405);
});

Deno.test("refetches the token once on a 401 and retries", async () => {
  // Order-independent: whatever the module's cached token is coming in
  // (shared state from earlier tests), the first IGDB call always 401s,
  // forcing a cache-clear-and-retry that must succeed on the second call.
  let igdbCalls = 0;

  await withMockedFetch((req) => {
    const url = req.url;
    if (url.startsWith("https://id.twitch.tv/")) {
      return Promise.resolve(
        new Response(
          JSON.stringify({ access_token: "fresh-tok", expires_in: 3600 }),
          { status: 200 },
        ),
      );
    }
    if (url === "https://api.igdb.com/v4/games") {
      igdbCalls += 1;
      if (igdbCalls === 1) {
        return Promise.resolve(
          new Response(JSON.stringify({ error: "expired" }), { status: 401 }),
        );
      }
      return Promise.resolve(
        new Response(JSON.stringify([{ id: 2 }]), { status: 200 }),
      );
    }
    throw new Error(`unexpected fetch to ${url}`);
  }, async () => {
    const res = await handler(
      post({ endpoint: "games", query: "fields name;" }),
    );
    assertEquals(res.status, 200);
    assertEquals(await res.json(), [{ id: 2 }]);
  });

  assertEquals(igdbCalls, 2);
});
