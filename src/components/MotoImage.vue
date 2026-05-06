<template>
  <div
    v-if="motor.photo"
    :class="className"
    :style="{
      backgroundImage: `url(${motor.photo})`,
      backgroundSize: 'cover',
      backgroundPosition: 'center',
    }"
  ></div>
  <MotoSilhouette
    v-else
    :category="motor.category"
    :colors="motor.colors"
    :className="className"
  />
</template>

<script setup>
import MotoSilhouette from './MotoSilhouette.vue';
defineProps({
  motor: { type: Object, required: true },
  className: { type: String, default: '' },
});
</script>
