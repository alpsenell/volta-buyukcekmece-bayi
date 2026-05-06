<template>
  <main class="catalog-page">
    <section class="page-head container">
      <div class="page-head-text">
        <div class="section-eyebrow">Tüm modeller</div>
        <h1 class="page-title">Motor kataloğu</h1>
        <p class="page-lead">
          Elektrikli scooter, ATV ve e-bisiklet modellerimiz. Bayi fiyatları KDV dahildir.
        </p>
      </div>
    </section>

    <section class="container catalog-toolbar">
      <div class="filter-tabs">
        <button :class="{ active: filter === 'all' }" @click="filter = 'all'">
          Tümü <span class="count">{{ store.motors.length }}</span>
        </button>
        <button :class="{ active: filter === 'scooter' }" @click="filter = 'scooter'">
          Scooter <span class="count">{{ countByCategory('scooter') }}</span>
        </button>
        <button :class="{ active: filter === 'atv' }" @click="filter = 'atv'">
          ATV <span class="count">{{ countByCategory('atv') }}</span>
        </button>
        <button :class="{ active: filter === 'bike' }" @click="filter = 'bike'">
          E-Bisiklet <span class="count">{{ countByCategory('bike') }}</span>
        </button>
      </div>

      <div class="toolbar-right">
        <select v-model="stockFilter" class="select">
          <option value="all">Stok durumu</option>
          <option value="in">Stokta</option>
          <option value="out">Tükendi</option>
        </select>
        <select v-model="sort" class="select">
          <option value="order">Önerilen</option>
          <option value="price-asc">Fiyat ↑</option>
          <option value="price-desc">Fiyat ↓</option>
          <option value="range-desc">Menzil ↓</option>
        </select>
        <select v-model="layout" class="select">
          <option value="grid">Grid</option>
          <option value="list">Liste</option>
        </select>
      </div>
    </section>

    <section class="container catalog-grid-section">
      <div v-if="filtered.length === 0" class="empty">
        <p>Bu filtrelere uygun motor bulunamadı.</p>
      </div>
      <div v-else :class="layout === 'list' ? 'moto-list' : 'moto-grid'">
        <MotoCard
          v-for="m in filtered" :key="m.id"
          :motor="m"
          :layout="layout"
        />
      </div>
    </section>
  </main>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import { useMotorStore } from '../stores/motors';
import MotoCard from '../components/MotoCard.vue';

const route = useRoute();
const store = useMotorStore();
const filter = ref('all');
const stockFilter = ref('all');
const sort = ref('order');
const layout = ref('grid');

onMounted(() => {
  if (route.query.cat) filter.value = route.query.cat;
});

function countByCategory(cat) {
  return store.motors.filter((m) => m.category === cat).length;
}

const filtered = computed(() => {
  let list = [...store.motors];
  if (filter.value !== 'all') list = list.filter((m) => m.category === filter.value);
  if (stockFilter.value === 'in') list = list.filter((m) => m.inStock);
  if (stockFilter.value === 'out') list = list.filter((m) => !m.inStock);

  if (sort.value === 'price-asc') list.sort((a, b) => a.price - b.price);
  else if (sort.value === 'price-desc') list.sort((a, b) => b.price - a.price);
  else if (sort.value === 'range-desc') list.sort((a, b) => b.range - a.range);
  else list.sort((a, b) => (a.order ?? 999) - (b.order ?? 999));

  return list;
});
</script>
