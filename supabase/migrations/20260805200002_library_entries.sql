-- library_entries: each game a user has added to their library.
--
-- igdb_id is the join key back to IGDB, plus a denormalised snapshot
-- (title, cover_url, release_date) so Library scrolling and Stats queries
-- can sort/filter server-side instead of round-tripping to IGDB per row.
create table public.library_entries (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  igdb_id bigint not null,
  title text not null,
  cover_url text,
  release_date date,
  -- The six statuses the design system defines, exactly.
  status text not null check (
    status in ('playing', 'backlog', 'completed', 'dropped', 'wishlist', 'on_hold')
  ),
  created_at timestamptz not null default now(),
  constraint library_entries_user_igdb_unique unique (user_id, igdb_id)
);

create index library_entries_user_id_idx on public.library_entries (user_id);

alter table public.library_entries enable row level security;

create policy "library_entries_select_own" on public.library_entries
  for select using (auth.uid() = user_id);

create policy "library_entries_insert_own" on public.library_entries
  for insert with check (auth.uid() = user_id);

create policy "library_entries_update_own" on public.library_entries
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "library_entries_delete_own" on public.library_entries
  for delete using (auth.uid() = user_id);
