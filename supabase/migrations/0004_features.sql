-- Volta Büyükçekmece Bayi — feature pack
-- Adds: FAQ table, compare-at price, visible flag, per-color photo tagging
-- Run AFTER 0003_admin_extensions.sql. Idempotent.

-- =========================================================================
-- 1. FAQ table (site-wide, admin-managed)
-- =========================================================================
create table if not exists public.faqs (
  id          uuid primary key default gen_random_uuid(),
  question    text not null,
  answer      text not null,
  sort_order  integer not null default 9999,
  visible     boolean not null default true,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

create index if not exists faqs_sort_order_idx on public.faqs (sort_order);
create index if not exists faqs_visible_idx    on public.faqs (visible);

drop trigger if exists faqs_set_updated_at on public.faqs;
create trigger faqs_set_updated_at
  before update on public.faqs
  for each row execute function public.set_updated_at();

alter table public.faqs enable row level security;

drop policy if exists "faqs public read"    on public.faqs;
drop policy if exists "faqs authed select"  on public.faqs;
drop policy if exists "faqs authed insert"  on public.faqs;
drop policy if exists "faqs authed update"  on public.faqs;
drop policy if exists "faqs authed delete"  on public.faqs;

-- Anonymous: only visible rows
create policy "faqs public read"
  on public.faqs for select
  using (visible);

-- Authenticated (admin): everything
create policy "faqs authed select"
  on public.faqs for select
  to authenticated
  using (true);

create policy "faqs authed insert"
  on public.faqs for insert
  to authenticated
  with check (true);

create policy "faqs authed update"
  on public.faqs for update
  to authenticated
  using (true) with check (true);

create policy "faqs authed delete"
  on public.faqs for delete
  to authenticated
  using (true);

-- Seed a handful of useful FAQs for the dealer site.
insert into public.faqs (question, answer, sort_order) values
  ('Online satış yapıyor musunuz?',
   'Hayır, bu site bilgi amaçlıdır. Satış için bayimizi ziyaret edin veya bizi arayın.', 10),
  ('Test sürüşü yapabilir miyim?',
   'Evet, randevu alarak showroom''umuzda dilediğiniz modeli test edebilirsiniz.', 20),
  ('Garanti süresi ne kadar?',
   'Tüm modellerimizde 2 yıl Volta Motor üretici garantisi vardır. Bazı bileşenler için ek garanti seçenekleri mevcuttur.', 30),
  ('Servis ve yedek parça hizmeti veriyor musunuz?',
   'Evet — periyodik bakım, batarya kontrolü ve yedek parça temini için bayimizden destek alabilirsiniz.', 40),
  ('Taksit / banka kredisi seçenekleri var mı?',
   'Peşin, banka kredisi ve taksit seçenekleri mevcuttur. Güncel detaylar için lütfen bayimizi arayın.', 50),
  ('Şarj süresi ve menzili ürün sayfasında belirtilen değerlere uyar mı?',
   'Belirtilen değerler ideal koşullarda ölçülmüştür. Gerçek menzil; sürücü ağırlığı, hız, eğim ve sıcaklığa bağlı olarak değişebilir.', 60)
on conflict do nothing;

-- =========================================================================
-- 2. Motors: compare_at price, visibility toggle, per-photo color tag
-- =========================================================================
alter table public.motors
  add column if not exists compare_price numeric(10,2);

alter table public.motors
  add column if not exists visible boolean not null default true;

alter table public.motors
  add column if not exists photo_colors text[] not null default '{}';

create index if not exists motors_visible_idx on public.motors (visible);

-- =========================================================================
-- 3. Motors RLS: filter hidden rows for anon, keep admin-visible
-- =========================================================================
drop policy if exists "motors public read"   on public.motors;
drop policy if exists "motors authed select" on public.motors;

create policy "motors public read"
  on public.motors for select
  using (visible);

create policy "motors authed select"
  on public.motors for select
  to authenticated
  using (true);
