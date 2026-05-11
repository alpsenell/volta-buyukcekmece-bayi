-- Volta Büyükçekmece Bayi — dynamic specs
-- Replaces fixed (range_km, top_speed, charge_hours) columns with a jsonb
-- array so each product (electric scooter, fuel motorcycle, e-bike, …)
-- can define its own spec rows. Idempotent.

-- =========================================================================
-- 1. Add specs jsonb column
-- =========================================================================
alter table public.motors
  add column if not exists specs jsonb not null default '[]'::jsonb;

-- =========================================================================
-- 2. Backfill specs from legacy columns (only when specs is still empty)
--    Each row becomes [{ label, value, unit }, ...]
-- =========================================================================
do $$
begin
  if exists (
    select 1 from information_schema.columns
    where table_schema = 'public' and table_name = 'motors' and column_name = 'range_km'
  ) then
    update public.motors set specs = (
      select coalesce(jsonb_agg(elem), '[]'::jsonb) from (
        select jsonb_build_object('label', 'Menzil',      'value', range_km::text,             'unit', 'km')   as elem where range_km     is not null
        union all
        select jsonb_build_object('label', 'Maks. hız',   'value', top_speed::text,            'unit', 'km/s') as elem where top_speed    is not null
        union all
        select jsonb_build_object('label', 'Şarj süresi', 'value', charge_hours::text,         'unit', 'sa')   as elem where charge_hours is not null
      ) sub
    )
    where specs is null or specs = '[]'::jsonb;
  end if;
end $$;

-- =========================================================================
-- 3. Drop legacy fixed-spec columns
-- =========================================================================
alter table public.motors drop column if exists range_km;
alter table public.motors drop column if exists top_speed;
alter table public.motors drop column if exists charge_hours;
