import 'package:gaming_library_assessment_flutter/features/auth/domain/entities/auth_status_entity.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/entities/authenticated_user_entity.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/entities/sign_in_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const _discordUserId = '9f1c2b64-3e7a-4d55-9c11-8a2d6f0b4e31';
const _googleUserId = '2b7d4a10-55c8-4f39-bd62-71e0c3a95f48';

User get mockDiscordUser => const User(
      id: _discordUserId,
      aud: 'authenticated',
      email: 'discord.player@example.com',
      createdAt: '2026-01-14T09:31:02.000Z',
      appMetadata: {
        'provider': 'discord',
        'providers': ['discord'],
      },
      userMetadata: {
        'full_name': 'Discord Player',
        'avatar_url': 'https://cdn.discordapp.com/avatars/1/a.png',
      },
    );

User get mockGoogleUser => const User(
      id: _googleUserId,
      aud: 'authenticated',
      email: 'google.player@example.com',
      createdAt: '2026-01-15T11:04:47.000Z',
      appMetadata: {
        'provider': 'google',
        'providers': ['google'],
      },
      userMetadata: {
        'full_name': 'Google Player',
        'avatar_url': 'https://lh3.googleusercontent.com/a/b.png',
      },
    );

Session get mockDiscordSession => Session(
      accessToken: 'discord-access-token',
      tokenType: 'bearer',
      refreshToken: 'discord-refresh-token',
      expiresIn: 3600,
      user: mockDiscordUser,
    );

Session get mockGoogleSession => Session(
      accessToken: 'google-access-token',
      tokenType: 'bearer',
      refreshToken: 'google-refresh-token',
      expiresIn: 3600,
      user: mockGoogleUser,
    );

AuthState get mockSignedInAuthState =>
    AuthState(AuthChangeEvent.signedIn, mockDiscordSession);

AuthState get mockSignedOutAuthState =>
    const AuthState(AuthChangeEvent.signedOut, null);

AuthState get mockTokenRefreshedAuthState =>
    AuthState(AuthChangeEvent.tokenRefreshed, mockDiscordSession);

AuthState get mockInitialSessionAuthState =>
    AuthState(AuthChangeEvent.initialSession, mockDiscordSession);

AuthenticatedUserEntity get mockDiscordUserEntity =>
    const AuthenticatedUserEntity(
      id: _discordUserId,
      provider: SignInProvider.discord,
      email: 'discord.player@example.com',
      displayName: 'Discord Player',
      avatarUrl: 'https://cdn.discordapp.com/avatars/1/a.png',
    );

AuthenticatedUserEntity get mockGoogleUserEntity =>
    const AuthenticatedUserEntity(
      id: _googleUserId,
      provider: SignInProvider.google,
      email: 'google.player@example.com',
      displayName: 'Google Player',
      avatarUrl: 'https://lh3.googleusercontent.com/a/b.png',
    );

AuthStatusEntity get mockDiscordSignedInStatus =>
    AuthStatusEntity.signedIn(mockDiscordUserEntity);

AuthStatusEntity get mockGoogleSignedInStatus =>
    AuthStatusEntity.signedIn(mockGoogleUserEntity);

AuthStatusEntity get mockSignedOutStatus => const AuthStatusEntity.signedOut();

AuthException get mockAuthException => const AuthException(
      'test auth error message',
      statusCode: '401',
      code: 'invalid_grant',
    );
