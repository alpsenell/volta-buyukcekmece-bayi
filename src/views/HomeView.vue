<template>
  <main>
    <!-- HERO -->
    <section class="hero hero-split">
      <div class="container hero-inner">
        <div class="hero-text">
          <div class="hero-eyebrow">
            <span class="eyebrow-dot"></span>
            Volta Motor Yetkili Bayi · Büyükçekmece
          </div>
          <h1 class="hero-title">
            Şehir senin,<br>
            <span class="hero-accent">enerji bizden.</span>
          </h1>
          <p class="hero-lead">
            Türkiye'nin elektrikli mobilite markası Volta Motor'un Büyükçekmece bayisinde
            scooter, ATV ve elektrikli bisiklet modellerimizi keşfedin.
          </p>
          <div class="hero-ctas">
            <RouterLink to="/katalog" class="btn btn-primary btn-lg">Tüm motorları gör</RouterLink>
            <RouterLink to="/iletisim" class="btn btn-ghost btn-lg">Bayiyi ziyaret et →</RouterLink>
          </div>
          <div class="hero-stats">
            <div class="hero-stat">
              <div class="stat-num">{{ store.motors.length }}</div>
              <div class="stat-label">Modelimiz</div>
            </div>
            <div class="hero-stat">
              <div class="stat-num">12+</div>
              <div class="stat-label">Yıllık deneyim</div>
            </div>
            <div class="hero-stat">
              <div class="stat-num">2 yıl</div>
              <div class="stat-label">Garanti</div>
            </div>
          </div>
        </div>

        <div class="hero-visual">
          <div class="hero-card-stack">
            <div
              v-for="(m, i) in featured.slice(0, 3)"
              :key="m.id"
              class="hero-stack-card"
              :class="`stack-${i}`"
              @click="$router.push(`/motor/${m.slug}`)"
            >
              <MotoImage :motor="m" className="hero-stack-image" />
              <div class="hero-stack-meta">
                <div class="hero-stack-name">{{ m.name }}</div>
                <div class="hero-stack-price">{{ formatPrice(m.price) }}</div>
              </div>
            </div>
            <div class="hero-bg-circle"></div>
          </div>
        </div>
      </div>
    </section>

    <!-- Kategoriler -->
    <section class="categories container">
      <RouterLink to="/katalog?cat=scooter" class="cat-card">
        <div class="cat-num">{{ totalScooter }}</div>
        <div class="cat-info">
          <h3>Elektrikli Scooter</h3>
          <p>Şehir içi günlük ulaşım için</p>
        </div>
        <div class="cat-arrow">→</div>
      </RouterLink>
      <RouterLink to="/katalog?cat=atv" class="cat-card">
        <div class="cat-num">{{ totalAtv }}</div>
        <div class="cat-info">
          <h3>Elektrikli ATV</h3>
          <p>Arazi ve eğlence kullanımı</p>
        </div>
        <div class="cat-arrow">→</div>
      </RouterLink>
      <RouterLink to="/katalog?cat=bike" class="cat-card">
        <div class="cat-num">{{ totalBike }}</div>
        <div class="cat-info">
          <h3>Elektrikli Bisiklet</h3>
          <p>Pedal destekli, sıfır emisyon</p>
        </div>
        <div class="cat-arrow">→</div>
      </RouterLink>
    </section>

    <!-- Öne çıkanlar -->
    <section class="featured-section container">
      <div class="section-head">
        <div>
          <div class="section-eyebrow">Öne çıkanlar</div>
          <h2 class="section-title">Bu hafta öne çıkardıklarımız</h2>
        </div>
        <RouterLink to="/katalog" class="btn btn-ghost">Tümünü gör →</RouterLink>
      </div>
      <div class="moto-grid">
        <MotoCard v-for="m in featured.slice(0, 6)" :key="m.id" :motor="m" />
      </div>
    </section>

    <!-- Neden biz -->
    <section class="why-section">
      <div class="container">
        <div class="section-head center">
          <div class="section-eyebrow">Neden Volta Büyükçekmece?</div>
          <h2 class="section-title">Sadece satış değil, baştan sona destek.</h2>
        </div>
        <div class="why-grid">
          <div class="why-card">
            <div class="why-num">01</div>
            <h3>Yetkili bayi</h3>
            <p>Volta Motor'un Büyükçekmece'deki resmi satış ve servis noktasıyız. Tüm modeller orijinal garantili.</p>
          </div>
          <div class="why-card">
            <div class="why-num">02</div>
            <h3>Test sürüşü imkânı</h3>
            <p>Karar vermeden önce showroom'umuzda dilediğiniz modeli denemenizi öneririz. Randevuyla.</p>
          </div>
          <div class="why-card">
            <div class="why-num">03</div>
            <h3>Servis & yedek parça</h3>
            <p>Periyodik bakım, batarya kontrolü, yedek parça temini — hepsi tek noktadan.</p>
          </div>
          <div class="why-card">
            <div class="why-num">04</div>
            <h3>Esnek ödeme</h3>
            <p>Peşin, taksit, banka kredisi seçenekleriyle ödeme planınızı birlikte oluşturalım.</p>
          </div>
        </div>
      </div>
    </section>

    <!-- CTA -->
    <section class="cta-section container">
      <div class="cta-card">
        <div>
          <h2>Showroom'umuzu ziyaret edin.</h2>
          <p>Atatürk Caddesi No: 123, Büyükçekmece. Hafta içi 09:00–19:00, Cumartesi 10:00–18:00.</p>
        </div>
        <RouterLink to="/iletisim" class="btn btn-primary btn-lg">Konum ve iletişim →</RouterLink>
      </div>
    </section>
  </main>
</template>

<script setup>
import { computed } from 'vue';
import { useMotorStore } from '../stores/motors';
import { formatPrice } from '../data/seed';
import MotoCard from '../components/MotoCard.vue';
import MotoImage from '../components/MotoImage.vue';

const store = useMotorStore();
const featured = computed(() => store.featured);
const totalScooter = computed(() => store.motors.filter((m) => m.category === 'scooter').length);
const totalAtv = computed(() => store.motors.filter((m) => m.category === 'atv').length);
const totalBike = computed(() => store.motors.filter((m) => m.category === 'bike').length);
</script>
