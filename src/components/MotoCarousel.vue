<template>
  <div class="moto-carousel">
    <div class="moto-carousel-stage">
      <div
        v-if="hasPhotos"
        class="moto-carousel-slide"
        :style="{ backgroundImage: `url(${activePhotos[index]})` }"
        :aria-label="`${motor.name} fotoğraf ${index + 1}`"
      ></div>
      <MotoSilhouette
        v-else
        :category="motor.category"
        :colors="motor.colors"
        className="moto-carousel-silhouette"
      />

      <button
        v-if="activePhotos.length > 1"
        class="moto-carousel-arrow prev"
        type="button"
        @click="prev"
        aria-label="Önceki fotoğraf"
      >‹</button>
      <button
        v-if="activePhotos.length > 1"
        class="moto-carousel-arrow next"
        type="button"
        @click="next"
        aria-label="Sonraki fotoğraf"
      >›</button>
    </div>

    <div v-if="activePhotos.length > 1" class="moto-carousel-thumbs">
      <button
        v-for="(p, i) in activePhotos"
        :key="`${p}-${i}`"
        type="button"
        class="moto-carousel-thumb"
        :class="{ active: i === index }"
        :style="{ backgroundImage: `url(${p})` }"
        @click="index = i"
        :aria-label="`Fotoğraf ${i + 1}`"
      ></button>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch } from 'vue';
import MotoSilhouette from './MotoSilhouette.vue';

const props = defineProps({
  motor: { type: Object, required: true },
  // Optional explicit photo list — used by DetailView to feed color-filtered photos.
  // When omitted, falls back to motor.photos (or legacy motor.photo).
  photos: { type: Array, default: null },
});

const index = ref(0);

const activePhotos = computed(() => {
  if (Array.isArray(props.photos)) return props.photos;
  const arr = Array.isArray(props.motor.photos) ? props.motor.photos : [];
  if (arr.length) return arr;
  if (props.motor.photo) return [props.motor.photo];
  return [];
});

const hasPhotos = computed(() => activePhotos.value.length > 0);

watch(
  () => props.motor.id,
  () => { index.value = 0; }
);

watch(activePhotos, (val) => {
  if (index.value >= val.length) index.value = 0;
});

function prev() {
  if (!activePhotos.value.length) return;
  index.value = (index.value - 1 + activePhotos.value.length) % activePhotos.value.length;
}
function next() {
  if (!activePhotos.value.length) return;
  index.value = (index.value + 1) % activePhotos.value.length;
}
</script>
