<template>
  <div class="color-dots">
    <span
      v-for="(c, i) in colors" :key="i"
      class="color-dot"
      :style="{ background: c, width: size + 'px', height: size + 'px' }"
      :title="c"
    ></span>
  </div>
</template>

<script setup>
defineProps({
  colors: { type: Array, default: () => [] },
  size: { type: Number, default: 14 },
});
</script>
