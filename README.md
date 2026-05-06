# Volta Büyükçekmece Bayi — Vue 3 + Vite

Volta Motor Büyükçekmece bayisi için Vue 3 + Vite ile hazırlanmış kurumsal site ve yönetim paneli.

## Teknolojiler

- **Vue 3** (Composition API, `<script setup>` SFC)
- **Vite 6** (dev server + build)
- **Vue Router 4** (history mode)
- **Pinia 2** (state management)
- localStorage ile motor envanter persistanslı

## Kurulum

```bash
cd vue-app
npm install
npm run dev
```

Geliştirme: <http://localhost:5173>

## Build

```bash
npm run build       # dist/ klasörüne üretim build'i
npm run preview     # build sonucunu lokal'de önizle
```

## Proje yapısı

```
vue-app/
├── index.html
├── package.json
├── vite.config.js
└── src/
    ├── main.js                 # uygulama giriş
    ├── App.vue                 # kök bileşen
    ├── router.js               # Vue Router (history mode + admin guard)
    ├── styles/main.css         # tüm site stilleri
    ├── data/seed.js            # seed motorlar + sabitler + helpers
    ├── stores/motors.js        # Pinia: motor envanter + auth
    ├── components/             # paylaşılan bileşenler
    │   ├── SiteHeader.vue
    │   ├── SiteFooter.vue
    │   ├── MotoCard.vue
    │   ├── MotoImage.vue
    │   ├── MotoSilhouette.vue
    │   ├── StockBadge.vue
    │   └── ColorDots.vue
    └── views/                  # sayfa bileşenleri
        ├── HomeView.vue
        ├── CatalogView.vue
        ├── DetailView.vue
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

**Yönetim paneli** (`/admin-login` ile giriş — demo şifre: `admin123`)
- `/admin` — Motor listesi (drag-drop sıralama, hızlı stok/öne-çıkar toggle, sil)
- `/admin/yeni` — Yeni motor ekleme
- `/admin/duzenle/:id` — Mevcut motor düzenleme (foto sürükle-bırak)

Admin route guard `router.js`'de — auth olmadan `/admin/*` ziyareti `/admin-login`'e yönlendirir.

## Veri

`localStorage['volta_bayi_motors_v1']` anahtarında saklanır. İlk açılışta `src/data/seed.js`'deki SEED_MOTORS otomatik yüklenir. Admin panelden "Tohum verisine sıfırla" ile geri alınabilir.

## Notlar

- Bu bir prototiptir — gerçek auth yok, demo şifre `admin123` istemcide kontrol ediliyor. Production'a almadan önce backend + JWT/session ekleyin.
- Foto upload'ı dataURL olarak localStorage'a kaydediliyor; üretimde gerçek bir storage'a yönlendirin.
- İletişim formu sadece UI seviyesinde — submit için backend bağlayın.
