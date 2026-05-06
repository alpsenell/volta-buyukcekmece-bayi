<template>
  <svg viewBox="0 0 400 240" :class="className">
    <template v-if="category === 'atv'">
      <defs>
        <pattern :id="`stripe-${stripeId}`" patternUnits="userSpaceOnUse" width="8" height="8" patternTransform="rotate(45)">
          <rect width="8" height="8" fill="#f5f5f4" />
          <rect width="4" height="8" fill="#e7e5e4" />
        </pattern>
      </defs>
      <rect x="0" y="0" width="400" height="240" :fill="`url(#stripe-${stripeId})`" opacity="0.4" />
      <ellipse cx="200" cy="160" rx="130" ry="40" :fill="c1" />
      <rect x="100" y="110" width="200" height="50" rx="12" :fill="c1" />
      <rect x="140" y="80" width="120" height="40" rx="8" :fill="c2" />
      <circle cx="90" cy="180" r="34" fill="#1c1917" />
      <circle cx="90" cy="180" r="18" fill="#57534e" />
      <circle cx="310" cy="180" r="34" fill="#1c1917" />
      <circle cx="310" cy="180" r="18" fill="#57534e" />
      <rect x="180" y="60" width="40" height="30" rx="4" :fill="c1" />
    </template>

    <template v-else-if="category === 'bike'">
      <rect x="0" y="0" width="400" height="240" fill="#fafaf9" />
      <line x1="100" y1="180" x2="200" y2="100" :stroke="c1" stroke-width="6" stroke-linecap="round" />
      <line x1="200" y1="100" x2="280" y2="180" :stroke="c1" stroke-width="6" stroke-linecap="round" />
      <line x1="200" y1="100" x2="200" y2="180" :stroke="c1" stroke-width="6" stroke-linecap="round" />
      <line x1="100" y1="180" x2="200" y2="180" :stroke="c1" stroke-width="6" stroke-linecap="round" />
      <rect x="160" y="120" width="60" height="20" rx="3" :fill="c2" />
      <circle cx="100" cy="180" r="40" fill="none" stroke="#1c1917" stroke-width="5" />
      <circle cx="100" cy="180" r="6" fill="#1c1917" />
      <circle cx="280" cy="180" r="40" fill="none" stroke="#1c1917" stroke-width="5" />
      <circle cx="280" cy="180" r="6" fill="#1c1917" />
      <ellipse cx="220" cy="98" rx="22" ry="6" :fill="c1" />
      <line x1="180" y1="100" x2="160" y2="80" :stroke="c1" stroke-width="6" stroke-linecap="round" />
    </template>

    <template v-else>
      <rect x="0" y="0" width="400" height="240" fill="#fafaf9" />
      <path d="M 80 180 Q 100 130, 180 130 L 240 130 Q 280 130, 290 100 L 310 100 L 310 130 Q 320 130, 320 145 L 320 180 Z" :fill="c1" />
      <rect x="180" y="115" width="80" height="20" rx="6" :fill="c2" />
      <rect x="295" y="92" width="20" height="14" rx="3" :fill="c2" />
      <circle cx="100" cy="190" r="32" fill="#1c1917" />
      <circle cx="100" cy="190" r="14" fill="#a8a29e" />
      <circle cx="300" cy="190" r="32" fill="#1c1917" />
      <circle cx="300" cy="190" r="14" fill="#a8a29e" />
      <line x1="290" y1="100" x2="270" y2="60" :stroke="c1" stroke-width="6" stroke-linecap="round" />
      <rect x="250" y="55" width="40" height="8" rx="3" :fill="c1" />
    </template>
  </svg>
</template>

<script setup>
import { computed } from 'vue';

const props = defineProps({
  category: { type: String, default: 'scooter' },
  colors: { type: Array, default: () => [] },
  className: { type: String, default: '' },
});

const c1 = computed(() => props.colors?.[0] || '#0a0a0a');
const c2 = computed(() => props.colors?.[1] || '#95c121');
const stripeId = computed(() => c1.value.replace('#', ''));
</script>
