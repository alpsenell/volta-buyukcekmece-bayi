-- Volta Büyükçekmece Bayi — seed data (8 motors)
-- Run AFTER 0001_init.sql. Safe to re-run (uses ON CONFLICT on slug).

insert into public.motors
  (slug, name, category, price, range_km, top_speed, charge_hours, colors, in_stock, featured, sort_order, description)
values
  ('lit',          'Volta Lit',          'scooter',  64900, 60,  45, 4,
   ARRAY['#0a0a0a','#dc2626','#f5f5f5'],            true,  true,  1,
   'Şehir içi günlük kullanım için ideal, hafif ve çevik elektrikli scooter. Kompakt gövde, sessiz motor.'),

  ('rks-max',      'Volta RKS Max',      'scooter',  89900, 110, 70, 6,
   ARRAY['#0a0a0a','#1d4ed8','#95c121'],            true,  true,  2,
   'Uzun menzilli sport scooter. İş ve uzun yol için güçlü performans, gelişmiş süspansiyon.'),

  ('cyclone',      'Volta Cyclone',      'scooter', 109900, 140, 90, 7,
   ARRAY['#0a0a0a','#dc2626'],                       false, true,  3,
   'Üst segment elektrikli motosiklet. ABS, dijital gösterge, akıllı bağlantı özellikleri.'),

  ('atv-pro',      'Volta ATV Pro',      'atv',     159900, 80,  55, 8,
   ARRAY['#0a0a0a','#16a34a','#ea580c'],            true,  false, 4,
   'Arazi ve çiftlik kullanımı için tasarlanmış 4 tekerlekli elektrikli ATV. Yüksek tork, dayanıklı şasi.'),

  ('atv-mini',     'Volta ATV Mini',     'atv',      79900, 50,  35, 5,
   ARRAY['#dc2626','#facc15','#0a0a0a'],            true,  false, 5,
   'Genç sürücüler ve hobi kullanıcıları için kompakt elektrikli ATV. Güvenli ve eğlenceli.'),

  ('e-bike-city',  'Volta E-Bike City',  'bike',     34900, 70,  25, 4,
   ARRAY['#0a0a0a','#f5f5f5','#95c121'],            true,  true,  6,
   'Şehir içi bisiklet kullanıcıları için pedal destekli elektrikli bisiklet. Şık tasarım, uzun menzil.'),

  ('e-bike-trail', 'Volta E-Bike Trail', 'bike',     49900, 90,  32, 5,
   ARRAY['#0a0a0a','#16a34a'],                       true,  false, 7,
   'Off-road ve dağ kullanımı için dayanıklı elektrikli bisiklet. Geniş tekerler, çift süspansiyon.'),

  ('urban-x',      'Volta Urban X',      'scooter',  74900, 75,  50, 5,
   ARRAY['#0a0a0a','#f5f5f5'],                       true,  false, 8,
   'Modern şehirli için minimal tasarım. Akıllı kilit, GPS takip, mobil uygulama desteği.')

on conflict (slug) do nothing;
