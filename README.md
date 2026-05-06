# Volta Büyükçekmece Bayi — Vue 3 + Vite + Supabase

Volta Motor Büyükçekmece bayisi için kurumsal site ve yönetim paneli.

## Teknolojiler

- **Vue 3** (Composition API, `<script setup>` SFC)
- **Vite 6** (dev server + build)
- **Vue Router 4** (history mode + admin guard)
- **Pinia 2** (state management)
- **Supabase** (Postgres veritabanı + Auth + Storage)
- **Vercel** için yapılandırılmış (`vercel.json` SPA rewrite + cache header)

## Hızlı başlangıç (yerel geliştirme)

```bash
npm install
cp .env.example .env.local       # sonra .env.local içini gerçek Supabase değerleriyle doldur
npm run dev
```

Geliştirme: <http://localhost:5173>

## Build

```bash
npm run build       # dist/ klasörüne üretim build'i
npm run preview     # build sonucunu lokal'de önizle
```

## Supabase kurulumu

1. <https://supabase.com> üzerinden yeni bir proje oluştur (region: `eu-central-1` Frankfurt önerilir, Türkiye'ye en yakın).
2. Project Settings → API: `Project URL` ve `anon public` anahtarını al, `.env.local` içine yaz:
   ```
   VITE_SUPABASE_URL=https://xxxx.supabase.co
   VITE_SUPABASE_ANON_KEY=eyJ...
   ```
3. SQL Editor'da sırayla çalıştır:
   - `supabase/migrations/0001_init.sql` (motors tablosu, RLS, storage bucket)
   - `supabase/migrations/0002_seed.sql` (8 başlangıç motoru)
4. Authentication → Providers → Email: kullan. Authentication → Sign-up: **kapat** (yalnızca dealer girebilsin).
5. Authentication → Users → "Add user": dealer için bir admin hesabı oluştur (e-posta + şifre).
6. `npm run dev` ile siteyi aç, `/admin-login` üzerinden gir.

## Proje yapısı

```
volta-buyukcekmece-bayi/
├── index.html                 # SEO meta + JSON-LD LocalBusiness
├── package.json
├── vercel.json                # SPA rewrite + cache header
├── vite.config.js
├── public/
│   ├── favicon.svg
│   ├── robots.txt
│   └── sitemap.xml
├── supabase/migrations/
│   ├── 0001_init.sql          # motors tablosu + RLS + storage bucket
│   └── 0002_seed.sql          # 8 başlangıç motoru
└── src/
    ├── main.js                # auth bootstrap → app mount
    ├── App.vue                # kök bileşen + ilk fetchAll
    ├── router.js              # rotalar + admin guard + SEO meta
    ├── lib/supabase.js        # Supabase client
    ├── styles/main.css
    ├── data/seed.js           # CATEGORY_LABELS + formatPrice + slugify
    ├── stores/motors.js       # Pinia: motors + auth (Supabase backed)
    ├── components/
    │   ├── SiteHeader.vue
    │   ├── SiteFooter.vue
    │   ├── MotoCard.vue
    │   ├── MotoImage.vue
    │   ├── MotoSilhouette.vue
    │   ├── StockBadge.vue
    │   └── ColorDots.vue
    └── views/
        ├── HomeView.vue
        ├── CatalogView.vue
        ├── DetailView.vue     # per-motor SEO + Product JSON-LD
        ├── AboutView.vue
        ├── ContactView.vue
        ├── NotFoundView.vue
        └── admin/
            ├── AdminLoginView.vue
            ├── AdminLayout.vue
            ├── AdminListView.vue
            └── AdminFormView.vue
```

## Sayfalar

**Genel site**
- `/` — Ana sayfa (hero + kategoriler + öne çıkanlar)
- `/katalog` — Tüm motorlar (filtre/sırala/grid-liste)
- `/motor/:slug` — Detay (özellikler + renk seçimi + benzer modeller)
- `/hakkimizda` — Hakkımızda
- `/iletisim` — İletişim (form + harita placeholder)

**Yönetim paneli** (`/admin-login` ile giriş — Supabase Auth e-posta + şifre)
- `/admin` — Motor listesi (drag-drop sıralama, hızlı stok/öne-çıkar toggle, sil)
- `/admin/yeni` — Yeni motor ekleme
- `/admin/duzenle/:id` — Mevcut motor düzenleme (foto Supabase Storage'a yükleniyor)

`/admin/*` rotaları admin guard'lı + `noindex, nofollow`.

## Vercel'e deploy

1. Repoyu GitHub'a push et.
2. <https://vercel.com> → New Project → ilgili repoyu seç. Vercel Vite'ı otomatik algılar.
3. Environment Variables'a ekle:
   - `VITE_SUPABASE_URL`
   - `VITE_SUPABASE_ANON_KEY`
4. Deploy. Custom domain için Project → Settings → Domains.

## SEO

- `index.html` içinde Open Graph + Twitter card + LocalBusiness (`AutomotiveBusiness`) JSON-LD.
- Her rotada dinamik `<title>` + `<meta description>` + canonical (`router.afterEach`).
- Detay sayfasında her motor için `Product` JSON-LD (fiyat + stok durumu).
- `public/robots.txt` + `public/sitemap.xml`. Domain değişince güncelle.

## Notlar

- Üretime almadan önce: Supabase'de Sign-up kapalı olduğundan emin ol; admin RLS politikalarını test et.
- İletişim formu UI seviyesinde — submit için Supabase'de bir `contact_messages` tablosu eklenebilir veya bir e-posta servisine bağlanabilir.
