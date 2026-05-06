<template>
  <main v-if="!motor" class="container empty-page">
    <h2>Motor bulunamadı</h2>
    <RouterLink to="/katalog" class="btn btn-primary">Kataloğa dön</RouterLink>
  </main>

  <main v-else class="detail-page">
    <div class="container">
      <RouterLink to="/katalog" class="breadcrumb">← Katalog</RouterLink>

      <div class="detail-grid">
        <div class="detail-image-side">
          <MotoCarousel :motor="motor" />
          <span v-if="motor.featured" class="featured-tag" style="margin-top: 12px; align-self: flex-start;">Öne çıkan</span>
        </div>

        <div class="detail-info-side">
          <div class="detail-cat">{{ categoryStore.labelOf(motor.category) }}</div>
          <h1 class="detail-title">{{ motor.name }}</h1>

          <div class="detail-meta">
            <StockBadge :in-stock="motor.inStock" />
            <span v-if="motor.featured" class="meta-tag">★ Öne çıkan</span>
          </div>

          <p class="detail-desc">{{ motor.description }}</p>

          <div class="detail-price-block">
            <div class="detail-price-label">Bayi fiyatı (KDV dahil)</div>
            <div class="detail-price">{{ formatPrice(motor.price) }}</div>
          </div>

          <div class="detail-specs">
            <div class="spec-row">
              <div class="spec">
                <div class="spec-label">Menzil</div>
                <div class="spec-value">{{ motor.range }} <span>km</span></div>
              </div>
              <div class="spec">
                <div class="spec-label">Maks. hız</div>
                <div class="spec-value">{{ motor.topSpeed }} <span>km/s</span></div>
              </div>
              <div class="spec">
                <div class="spec-label">Şarj süresi</div>
                <div class="spec-value">{{ motor.chargeTime }} <span>saat</span></div>
              </div>
            </div>
          </div>

          <div v-if="motor.colors && motor.colors.length > 1" class="detail-colors">
            <div class="detail-colors-label">Renk seçenekleri</div>
            <div class="detail-colors-row">
              <button
                v-for="(c, i) in motor.colors" :key="i"
                class="color-pick"
                :class="{ active: selectedColor === i }"
                @click="selectedColor = i"
                :aria-label="`Renk ${i + 1}`"
              >
                <span :style="{ background: c }"></span>
              </button>
            </div>
          </div>

          <div class="detail-cta-row">
            <RouterLink to="/iletisim" class="btn btn-primary btn-lg">Bayiden bilgi al</RouterLink>
            <a v-if="phoneHref" :href="phoneHref" class="btn btn-ghost btn-lg">Hemen ara</a>
          </div>

          <div class="detail-note">
            ⚠ Bu site bilgi amaçlıdır, online satış yapılmamaktadır. Satış için lütfen bayimizi arayın veya ziyaret edin.
          </div>
        </div>
      </div>

      <section v-if="related.length" class="related">
        <h2 class="section-title">Benzer modeller</h2>
        <div class="moto-grid">
          <MotoCard v-for="m in related" :key="m.id" :motor="m" />
        </div>
      </section>
    </div>
  </main>
</template>

<script setup>
import { ref, computed, watch, watchEffect } from 'vue';
import { useRoute } from 'vue-router';
import { useMotorStore } from '../stores/motors';
import { useCategoryStore, useSettingsStore } from '../stores/site';
import { formatPrice } from '../data/seed';
import MotoCarousel from '../components/MotoCarousel.vue';
import StockBadge from '../components/StockBadge.vue';
import MotoCard from '../components/MotoCard.vue';

const route = useRoute();
const store = useMotorStore();
const categoryStore = useCategoryStore();
const settingsStore = useSettingsStore();
const selectedColor = ref(0);

const motor = computed(() => store.bySlug(route.params.slug));
const related = computed(() => {
  if (!motor.value) return [];
  return store.motors
    .filter((m) => m.category === motor.value.category && m.id !== motor.value.id)
    .slice(0, 3);
});

const phoneHref = computed(() => {
  const p = settingsStore.settings?.phone;
  if (!p) return null;
  const cleaned = p.replace(/[^+\d]/g, '');
  return cleaned ? `tel:${cleaned}` : null;
});

watch(() => route.params.slug, () => { selectedColor.value = 0; });

// Per-motor SEO: title + meta description + Product JSON-LD
let jsonLdEl = null;
watchEffect(() => {
  if (typeof document === 'undefined') return;
  const m = motor.value;
  if (!m) return;
  const catLabel = categoryStore.labelOf(m.category);
  document.title = `${m.name} · Volta Motor Büyükçekmece Bayi`;
  const desc = `${m.name} — ${catLabel}. Menzil ${m.range} km, maks. hız ${m.topSpeed} km/s, şarj ${m.chargeTime} saat. ${formatPrice(m.price)}`;
  let metaDesc = document.head.querySelector('meta[name="description"]');
  if (!metaDesc) {
    metaDesc = document.createElement('meta');
    metaDesc.setAttribute('name', 'description');
    document.head.appendChild(metaDesc);
  }
  metaDesc.setAttribute('content', desc);

  const photos = Array.isArray(m.photos) ? m.photos : [];
  const ld = {
    '@context': 'https://schema.org',
    '@type': 'Product',
    name: m.name,
    description: m.description || desc,
    category: catLabel,
    image: photos.length ? photos : undefined,
    brand: { '@type': 'Brand', name: 'Volta Motor' },
    offers: {
      '@type': 'Offer',
      price: m.price,
      priceCurrency: 'TRY',
      availability: m.inStock ? 'https://schema.org/InStock' : 'https://schema.org/OutOfStock',
      url: typeof window !== 'undefined' ? window.location.href : undefined,
    },
  };
  if (!jsonLdEl) {
    jsonLdEl = document.createElement('script');
    jsonLdEl.setAttribute('type', 'application/ld+json');
    jsonLdEl.setAttribute('data-detail-jsonld', '');
    document.head.appendChild(jsonLdEl);
  }
  jsonLdEl.textContent = JSON.stringify(ld);
});
</script>
