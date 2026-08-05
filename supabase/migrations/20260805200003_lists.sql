-- lists: a stub only, enough to prove the shape. Custom lists are a
-- deferred Pro feature -- no list membership/items table yet.
create table public.lists (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  name text not null,
  created_at timestamptz not null default now()
);

create index lists_user_id_idx on public.lists (user_id);

alter table public.lists enable row level security;

create policy "lists_select_own" on public.lists
  for select using (auth.uid() = user_id);

create policy "lists_insert_own" on public.lists
  for insert with check (auth.uid() = user_id);

create policy "lists_update_own" on public.lists
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "lists_delete_own" on public.lists
  for delete using (auth.uid() = user_id);
