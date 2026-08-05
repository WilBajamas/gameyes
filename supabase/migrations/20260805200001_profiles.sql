-- profiles: one row per auth.users row, created automatically at sign-up.
create table public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  -- Entitlement column for the future Pro tier. Nullable and never read in
  -- v1 -- added now because adding it later means migrating a live table.
  tier text,
  created_at timestamptz not null default now()
);

-- Runs as the table owner so it can insert despite RLS, the only way a
-- profiles row is ever created -- there is no user-facing insert policy.
create function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id) values (new.id);
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

alter table public.profiles enable row level security;

create policy "profiles_select_own" on public.profiles
  for select using (auth.uid() = id);

create policy "profiles_update_own" on public.profiles
  for update using (auth.uid() = id) with check (auth.uid() = id);

-- No insert or delete policy: insert only ever happens via the trigger
-- above (security definer, bypasses RLS); delete happens by the `on delete
-- cascade` above when the auth.users row is removed, never directly.
