<template>
  <div>
    <SiteHeader v-if="!isAdminRoute" />
    <RouterView />
    <SiteFooter v-if="!isAdminRoute" />
  </div>
</template>

<script setup>
import { computed } from 'vue';
import { useRoute } from 'vue-router';
import SiteHeader from './components/SiteHeader.vue';
import SiteFooter from './components/SiteFooter.vue';

const route = useRoute();
const isAdminRoute = computed(() => route.path.startsWith('/admin'));
</script>
