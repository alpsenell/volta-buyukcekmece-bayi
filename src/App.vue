<template>
  <div>
    <SiteHeader v-if="!isAdminRoute" />
    <RouterView />
    <SiteFooter v-if="!isAdminRoute" />
  </div>
</template>

<script setup>
import { computed, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import SiteHeader from './components/SiteHeader.vue';
import SiteFooter from './components/SiteFooter.vue';
import { useMotorStore } from './stores/motors';

const route = useRoute();
const isAdminRoute = computed(() => route.path.startsWith('/admin'));
const motorStore = useMotorStore();

onMounted(() => {
  motorStore.fetchAll();
});
</script>
