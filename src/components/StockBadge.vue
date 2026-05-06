<template>
  <span class="stock-badge" :class="inStock ? 'in-stock' : 'out-stock'">
    <span class="stock-dot"></span>
    {{ inStock ? 'Stokta' : 'Tükendi' }}
  </span>
</template>

<script setup>
defineProps({ inStock: Boolean });
</script>
