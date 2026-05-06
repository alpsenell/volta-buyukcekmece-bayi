-- Volta Büyükçekmece Bayi — initial schema
-- Run this in the Supabase SQL editor (or via supabase CLI db push)

-- =========================================================================
-- 1. motors table
-- =========================================================================
create table public.motors (
  id            uuid primary key default gen_random_uuid(),
  slug          text not null unique,
  name          text not null,
  category      text not null check (category in ('scooter', 'atv', 'bike')),
  price         numeric(10,2) not null check (price >= 0),
  range_km      integer not null check (range_km >= 0),
  top_speed     integer not null check (top_speed >= 0),
  charge_hours  numeric(4,1) not null check (charge_hours >= 0),
  colors        text[] not null default '{}',
  in_stock      boolean not null default true,
  featured      boolean not null default false,
  sort_order    integer not null default 9999,
  description   text,
  image_url     text,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);

comment on table public.motors is 'Volta dealer motor inventory (catalog).';

create index motors_sort_order_idx on public.motors (sort_order);
create index motors_category_idx   on public.motors (category);
create index motors_in_stock_idx   on public.motors (in_stock);

-- =========================================================================
-- 2. updated_at trigger
-- =========================================================================
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger motors_set_updated_at
  before update on public.motors
  for each row execute function public.set_updated_at();

-- =========================================================================
-- 3. Row Level Security
--    Public site: anyone can read.
--    Admin: only authenticated users (real Supabase Auth users) can write.
--    Sign-ups must be DISABLED in the Supabase dashboard so only the dealer's
--    pre-created admin account can sign in.
-- =========================================================================
alter table public.motors enable row level security;

create policy "motors public read"
  on public.motors for select
  using (true);

create policy "motors authed insert"
  on public.motors for insert
  to authenticated
  with check (true);

create policy "motors authed update"
  on public.motors for update
  to authenticated
  using (true)
  with check (true);

create policy "motors authed delete"
  on public.motors for delete
  to authenticated
  using (true);

-- =========================================================================
-- 4. Storage bucket for motor photos
--    Public read so the catalog can render images directly via the public URL.
--    Only authenticated users can upload/update/delete.
-- =========================================================================
insert into storage.buckets (id, name, public)
values ('motor-photos', 'motor-photos', true)
on conflict (id) do nothing;

create policy "motor-photos public read"
  on storage.objects for select
  using (bucket_id = 'motor-photos');

create policy "motor-photos authed insert"
  on storage.objects for insert
  to authenticated
  with check (bucket_id = 'motor-photos');

create policy "motor-photos authed update"
  on storage.objects for update
  to authenticated
  using (bucket_id = 'motor-photos');

create policy "motor-photos authed delete"
  on storage.objects for delete
  to authenticated
  using (bucket_id = 'motor-photos');
