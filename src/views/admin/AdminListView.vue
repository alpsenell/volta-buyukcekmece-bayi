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
        <button class="btn btn-ghost" @click="resetSeed">Tohum verisine sıfırla</button>
        <RouterLink to="/admin/yeni" class="btn btn-primary">+ Yeni motor</RouterLink>
      </div>
    </div>

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
            <td>{{ CATEGORY_LABELS[m.category] }}</td>
            <td class="num">{{ formatPrice(m.price) }}</td>
            <td>
              <button
                class="toggle-pill"
                :class="m.inStock ? 'on' : 'off'"
                @click="store.updateMotor(m.id, { inStock: !m.inStock })"
              >
                {{ m.inStock ? 'Stokta' : 'Tükendi' }}
              </button>
            </td>
            <td>
              <button
                class="toggle-pill"
                :class="m.featured ? 'on' : 'off'"
                @click="store.updateMotor(m.id, { featured: !m.featured })"
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
import { ref, computed } from 'vue';
import { useMotorStore } from '../../stores/motors';
import { CATEGORY_LABELS, formatPrice } from '../../data/seed';
import MotoImage from '../../components/MotoImage.vue';

const store = useMotorStore();
const sortedMotors = computed(() => store.sorted);
const dragIndex = ref(null);

function dragStart(i, e) {
  dragIndex.value = i;
  e.dataTransfer.effectAllowed = 'move';
}

function drop(i) {
  if (dragIndex.value === null || dragIndex.value === i) return;
  const next = [...sortedMotors.value];
  const [moved] = next.splice(dragIndex.value, 1);
  next.splice(i, 0, moved);
  store.reorderMotors(next);
  dragIndex.value = null;
}

function confirmDelete(m) {
  if (confirm(`"${m.name}" silinecek. Emin misiniz?`)) {
    store.deleteMotor(m.id);
  }
}

function resetSeed() {
  if (confirm('Tüm değişiklikler silinip başlangıç verisi geri yüklenecek. Devam edilsin mi?')) {
    store.resetToSeed();
  }
}
</script>
