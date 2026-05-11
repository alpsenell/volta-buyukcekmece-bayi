<template>
  <header class="site-header">
    <div class="container header-inner">
      <RouterLink to="/" class="brand">
        <img
          v-if="settings.logo_url"
          :src="settings.logo_url"
          alt="Logo"
          class="brand-logo-img"
        />
        <template v-else>
          <span class="brand-mark" aria-hidden="true">
            <svg viewBox="0 0 32 32" width="28" height="28">
              <path d="M 8 4 L 16 28 L 24 4 L 19 4 L 16 18 L 13 4 Z" fill="currentColor" />
            </svg>
          </span>
          <span class="brand-text">
            <span class="brand-name">VOLTA</span>
            <span class="brand-sub">Büyükçekmece Bayi</span>
          </span>
        </template>
      </RouterLink>

      <nav class="site-nav" :class="{ open: menuOpen }">
        <RouterLink
          v-for="l in links" :key="l.path"
          :to="l.path"
          class="nav-link"
          active-class="active"
          :exact-active-class="l.path === '/' ? 'active' : ''"
          @click="menuOpen = false"
        >{{ l.label }}</RouterLink>
      </nav>

      <div class="header-actions">
        <a v-if="phoneHref" :href="phoneHref" class="header-phone">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/>
          </svg>
          <span>{{ settings.phone }}</span>
        </a>
        <RouterLink to="/katalog" class="btn btn-primary">Modelleri Gör</RouterLink>
        <button class="menu-toggle" @click="menuOpen = !menuOpen" aria-label="Menü">
          <span></span><span></span><span></span>
        </button>
      </div>
    </div>
  </header>
</template>

<script setup>
import { ref, computed } from 'vue';
import { useSettingsStore } from '../stores/site';

const menuOpen = ref(false);
const settingsStore = useSettingsStore();
const settings = computed(() => settingsStore.settings);

const phoneHref = computed(() => {
  const p = settings.value.phone;
  if (!p) return null;
  const cleaned = p.replace(/[^+\d]/g, '');
  return cleaned ? `tel:${cleaned}` : null;
});

const links = [
  { path: '/', label: 'Ana Sayfa' },
  { path: '/katalog', label: 'Modeller' },
  { path: '/hakkimizda', label: 'Hakkımızda' },
  { path: '/sss', label: 'SSS' },
  { path: '/iletisim', label: 'İletişim' },
];
</script>
