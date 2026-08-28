-- The six columns the Library spec needs. Added, never replacing what is
-- already on the table: the applied migration stays byte-identical.
alter table public.library_entries
  add column platform text,
  add column rating int,
  add column playtime_hours numeric,
  add column progress_percent numeric,
  add column genre text,
  add column updated_at timestamptz not null default now();

-- 0 is not "unrated" -- an absent rating is null, so 0 must be rejected
-- rather than stored and later rendered as a one-star verdict.
alter table public.library_entries
  add constraint library_entries_rating_range
    check (rating is null or (rating >= 1 and rating <= 10)),
  add constraint library_entries_progress_percent_range
    check (progress_percent is null or
           (progress_percent >= 0 and progress_percent <= 100)),
  add constraint library_entries_playtime_hours_non_negative
    check (playtime_hours is null or playtime_hours >= 0);
