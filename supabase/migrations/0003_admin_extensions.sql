-- Volta Büyükçekmece Bayi — admin extensions
-- Adds: categories table, multi-image support on motors, site_settings,
-- and a site-assets storage bucket for logo / hero images.
-- Run AFTER 0001_init.sql + 0002_seed.sql.

-- =========================================================================
-- 1. Categories table (admin-managed)
-- =========================================================================
create table if not exists public.categories (
  id          uuid primary key default gen_random_uuid(),
  slug        text not null unique,
  label       text not null,
  sort_order  integer not null default 9999,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

create index if not exists categories_sort_order_idx on public.categories (sort_order);

drop trigger if exists categories_set_updated_at on public.categories;
create trigger categories_set_updated_at
  before update on public.categories
  for each row execute function public.set_updated_at();

alter table public.categories enable row level security;

drop policy if exists "categories public read"   on public.categories;
drop policy if exists "categories authed insert" on public.categories;
drop policy if exists "categories authed update" on public.categories;
drop policy if exists "categories authed delete" on public.categories;

create policy "categories public read"   on public.categories for select using (true);
create policy "categories authed insert" on public.categories for insert to authenticated with check (true);
create policy "categories authed update" on public.categories for update to authenticated using (true) with check (true);
create policy "categories authed delete" on public.categories for delete to authenticated using (true);

-- Seed initial 3 categories from the legacy enum.
insert into public.categories (slug, label, sort_order) values
  ('scooter', 'Scooter',     1),
  ('atv',     'ATV',         2),
  ('bike',    'E-Bisiklet',  3)
on conflict (slug) do nothing;

-- =========================================================================
-- 2. Motors: drop legacy CHECK enum, add multi-image array
-- =========================================================================
do $$
begin
  if exists (
    select 1 from information_schema.constraint_column_usage
    where constraint_name = 'motors_category_check' and table_name = 'motors'
  ) then
    alter table public.motors drop constraint motors_category_check;
  end if;
end $$;

alter table public.motors
  add column if not exists images text[] not null default '{}';

-- Backfill: existing image_url → images[0]
update public.motors
   set images = ARRAY[image_url]
 where image_url is not null
   and image_url <> ''
   and array_length(images, 1) is null;

alter table public.motors
  drop column if exists image_url;

-- =========================================================================
-- 3. Site settings (singleton — exactly one row, id = 1)
-- =========================================================================
create table if not exists public.site_settings (
  id                integer primary key default 1,
  logo_url          text,
  address           text,
  phone             text,
  email             text,
  working_hours     text,
  map_lat           numeric(9,6),
  map_lng           numeric(9,6),
  hero_title        text,
  hero_subtitle     text,
  hero_cta_label    text,
  hero_cta_href     text,
  hero_image_url    text,
  social_facebook   text,
  social_instagram  text,
  social_youtube    text,
  updated_at        timestamptz not null default now(),
  constraint site_settings_singleton check (id = 1)
);

drop trigger if exists site_settings_set_updated_at on public.site_settings;
create trigger site_settings_set_updated_at
  before update on public.site_settings
  for each row execute function public.set_updated_at();

alter table public.site_settings enable row level security;

drop policy if exists "site_settings public read"   on public.site_settings;
drop policy if exists "site_settings authed insert" on public.site_settings;
drop policy if exists "site_settings authed update" on public.site_settings;

create policy "site_settings public read"   on public.site_settings for select using (true);
create policy "site_settings authed insert" on public.site_settings for insert to authenticated with check (true);
create policy "site_settings authed update" on public.site_settings for update to authenticated using (true) with check (true);

-- Seed default singleton row.
insert into public.site_settings (
  id, address, phone, email, working_hours,
  hero_title, hero_subtitle, hero_cta_label, hero_cta_href
) values (
  1,
  'Büyükçekmece, İstanbul',
  '+90 000 000 0000',
  'info@volta-bayi.com',
  'Pzt-Cmt 09:00-19:00',
  'Şehir senin, enerji bizden.',
  'Volta Motor Büyükçekmece bayisinde scooter, ATV ve elektrikli bisiklet modellerimizi keşfedin.',
  'Tüm motorları gör',
  '/katalog'
)
on conflict (id) do nothing;

-- =========================================================================
-- 4. site-assets storage bucket (public read, authed write) for logo / hero
-- =========================================================================
insert into storage.buckets (id, name, public)
values ('site-assets', 'site-assets', true)
on conflict (id) do nothing;

drop policy if exists "site-assets public read"   on storage.objects;
drop policy if exists "site-assets authed insert" on storage.objects;
drop policy if exists "site-assets authed update" on storage.objects;
drop policy if exists "site-assets authed delete" on storage.objects;

create policy "site-assets public read"
  on storage.objects for select
  using (bucket_id = 'site-assets');

create policy "site-assets authed insert"
  on storage.objects for insert
  to authenticated
  with check (bucket_id = 'site-assets');

create policy "site-assets authed update"
  on storage.objects for update
  to authenticated
  using (bucket_id = 'site-assets');

create policy "site-assets authed delete"
  on storage.objects for delete
  to authenticated
  using (bucket_id = 'site-assets');
