<template>
  <div class="admin-page">
    <div class="admin-page-head">
      <div>
        <h1>Motorlar</h1>
        <p class="admin-page-lead">
          Toplam {{ store.stats.total }} motor · {{ store.stats.inStock }} stokta · {{ store.stats.featured }} öne çıkan
        </p>
      </div>
      <div class="admin-page-actions">
        <button class="btn btn-ghost" @click="refresh" :disabled="store.loading">
          {{ store.loading ? 'Yükleniyor…' : '↻ Yenile' }}
        </button>
        <RouterLink to="/admin/yeni" class="btn btn-primary">+ Yeni motor</RouterLink>
      </div>
    </div>

    <p v-if="store.error" class="form-error">{{ store.error }}</p>

    <div class="admin-stats-row">
      <div class="admin-stat-card">
        <div class="admin-stat-num">{{ store.stats.total }}</div>
        <div class="admin-stat-label">Toplam motor</div>
      </div>
      <div class="admin-stat-card">
        <div class="admin-stat-num">{{ store.stats.inStock }}</div>
        <div class="admin-stat-label">Stokta</div>
      </div>
      <div class="admin-stat-card">
        <div class="admin-stat-num">{{ store.stats.featured }}</div>
        <div class="admin-stat-label">Öne çıkan</div>
      </div>
      <div class="admin-stat-card">
        <div class="admin-stat-num">{{ store.stats.total - store.stats.inStock }}</div>
        <div class="admin-stat-label">Stok yok</div>
      </div>
    </div>

    <div class="admin-table-wrap">
      <table class="admin-table">
        <thead>
          <tr>
            <th class="col-drag"></th>
            <th class="col-img">Görsel</th>
            <th>Model</th>
            <th>Kategori</th>
            <th>Fiyat</th>
            <th>Stok</th>
            <th>Öne çıkan</th>
            <th class="col-actions">İşlem</th>
          </tr>
        </thead>
        <tbody>
          <tr
            v-for="(m, i) in sortedMotors" :key="m.id"
            draggable="true"
            @dragstart="dragStart(i, $event)"
            @dragover.prevent
            @drop="drop(i)"
            :class="{ dragging: dragIndex === i }"
          >
            <td class="col-drag"><span class="drag-handle">⋮⋮</span></td>
            <td class="col-img">
              <div class="admin-thumb">
                <MotoImage :motor="m" className="admin-thumb-img" />
              </div>
            </td>
            <td>
              <div class="admin-cell-strong">{{ m.name }}</div>
              <div class="admin-cell-sub">/{{ m.slug }}</div>
            </td>
            <td>{{ categoryStore.labelOf(m.category) }}</td>
            <td class="num">{{ formatPrice(m.price) }}</td>
            <td>
              <button
                class="toggle-pill"
                :class="m.inStock ? 'on' : 'off'"
                @click="toggleStock(m)"
              >
                {{ m.inStock ? 'Stokta' : 'Tükendi' }}
              </button>
            </td>
            <td>
              <button
                class="toggle-pill"
                :class="m.featured ? 'on' : 'off'"
                @click="toggleFeatured(m)"
              >
                {{ m.featured ? '★ Evet' : 'Hayır' }}
              </button>
            </td>
            <td class="col-actions">
              <RouterLink :to="`/admin/duzenle/${m.id}`" class="btn-table">Düzenle</RouterLink>
              <button class="btn-table danger" @click="confirmDelete(m)">Sil</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <p class="admin-table-hint">
      ↕ Sıraları değiştirmek için satırları sürükleyebilirsiniz.
    </p>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useMotorStore } from '../../stores/motors';
import { useCategoryStore } from '../../stores/site';
import { formatPrice } from '../../data/seed';
import MotoImage from '../../components/MotoImage.vue';

const store = useMotorStore();
const categoryStore = useCategoryStore();
const sortedMotors = computed(() => store.sorted);
const dragIndex = ref(null);

onMounted(() => {
  if (!store.loaded) store.fetchAll();
});

function dragStart(i, e) {
  dragIndex.value = i;
  e.dataTransfer.effectAllowed = 'move';
}

async function drop(i) {
  if (dragIndex.value === null || dragIndex.value === i) return;
  const next = [...sortedMotors.value];
  const [moved] = next.splice(dragIndex.value, 1);
  next.splice(i, 0, moved);
  dragIndex.value = null;
  try { await store.reorderMotors(next); }
  catch (e) { console.error('reorder failed', e); }
}

async function confirmDelete(m) {
  if (!confirm(`"${m.name}" silinecek. Emin misiniz?`)) return;
  try { await store.deleteMotor(m.id); }
  catch (e) { alert('Silinemedi: ' + (e.message || e)); }
}

async function toggleStock(m) {
  try { await store.updateMotor(m.id, { inStock: !m.inStock }); }
  catch (e) { alert('Güncellenemedi: ' + (e.message || e)); }
}

async function toggleFeatured(m) {
  try { await store.updateMotor(m.id, { featured: !m.featured }); }
  catch (e) { alert('Güncellenemedi: ' + (e.message || e)); }
}

function refresh() {
  store.fetchAll(true);
}
</script>
