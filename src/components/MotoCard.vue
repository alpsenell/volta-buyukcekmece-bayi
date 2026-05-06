<template>
  <article v-if="layout === 'list'" class="moto-card list" @click="goDetail">
    <div class="moto-card-image-wrap list">
      <MotoImage :motor="motor" className="moto-card-image" />
    </div>
    <div class="moto-card-body list">
      <div class="moto-card-top">
        <div class="moto-card-cat">{{ CATEGORY_LABELS[motor.category] }}</div>
        <StockBadge :in-stock="motor.inStock" />
      </div>
      <h3 class="moto-card-title">{{ motor.name }}</h3>
      <div class="moto-card-specs">
        <span><strong>{{ motor.range }}</strong> km menzil</span>
        <span><strong>{{ motor.topSpeed }}</strong> km/s</span>
        <span><strong>{{ motor.chargeTime }}</strong> sa şarj</span>
      </div>
      <ColorDots :colors="motor.colors" />
    </div>
    <div class="moto-card-price-wrap">
      <div class="moto-card-price-label">Bayi fiyatı</div>
      <div class="moto-card-price">{{ formatPrice(motor.price) }}</div>
      <button class="btn-link">İncele →</button>
    </div>
  </article>

  <article v-else class="moto-card grid" @click="goDetail">
    <div class="moto-card-image-wrap">
      <MotoImage :motor="motor" className="moto-card-image" />
      <span v-if="motor.featured" class="featured-tag">Öne çıkan</span>
      <StockBadge :in-stock="motor.inStock" />
    </div>
    <div class="moto-card-body">
      <div class="moto-card-cat">{{ CATEGORY_LABELS[motor.category] }}</div>
      <h3 class="moto-card-title">{{ motor.name }}</h3>
      <div class="moto-card-specs">
        <span><strong>{{ motor.range }}</strong> km</span>
        <span class="dot-sep">·</span>
        <span><strong>{{ motor.topSpeed }}</strong> km/s</span>
        <span class="dot-sep">·</span>
        <span><strong>{{ motor.chargeTime }}</strong> sa</span>
      </div>
      <div class="moto-card-bottom">
        <ColorDots :colors="motor.colors" />
        <div class="moto-card-price">{{ formatPrice(motor.price) }}</div>
      </div>
    </div>
  </article>
</template>

<script setup>
import { useRouter } from 'vue-router';
import MotoImage from './MotoImage.vue';
import StockBadge from './StockBadge.vue';
import ColorDots from './ColorDots.vue';
import { CATEGORY_LABELS, formatPrice } from '../data/seed';

const props = defineProps({
  motor: { type: Object, required: true },
  layout: { type: String, default: 'grid' },
});

const router = useRouter();
function goDetail() {
  router.push(`/motor/${props.motor.slug}`);
}
</script>
