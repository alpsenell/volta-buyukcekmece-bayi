<template>
  <div class="admin-page">
    <div class="admin-page-head">
      <div>
        <h1>Kategoriler</h1>
        <p class="admin-page-lead">
          Ürün kategorilerini yönetin. Bir kategoriyi silmeden önce o kategorideki tüm modelleri başka bir kategoriye taşıyın.
        </p>
      </div>
      <div class="admin-page-actions">
        <button class="btn btn-primary" @click="openNew">+ Yeni kategori</button>
      </div>
    </div>

    <p v-if="error" class="form-error">{{ error }}</p>

    <div v-if="form.show" class="form-section" style="margin-bottom: 24px">
      <h3>{{ form.id ? 'Kategoriyi düzenle' : 'Yeni kategori' }}</h3>
      <form @submit.prevent="save" class="admin-form">
        <div class="field-row">
          <label class="field">
            <span>İsim (kullanıcıya görünen)</span>
            <input type="text" v-model="form.label" required placeholder="Örn: Elektrikli Motosiklet" />
          </label>
          <label class="field">
            <span>Sıralama</span>
            <input type="number" v-model.number="form.sort_order" min="0" />
          </label>
        </div>
        <div class="admin-form-actions">
          <button type="button" class="btn btn-ghost" @click="form.show = false">İptal</button>
          <button type="submit" class="btn btn-primary" :disabled="saving">
            {{ saving ? 'Kaydediliyor…' : (form.id ? 'Kaydet' : 'Ekle') }}
          </button>
        </div>
      </form>
    </div>

    <div class="admin-table-wrap">
      <table class="admin-table admin-categories-table">
        <thead>
          <tr>
            <th style="width: 80px">Sıra</th>
            <th>İsim</th>
            <th>Slug</th>
            <th>Motor sayısı</th>
            <th class="col-actions">İşlem</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="c in sorted" :key="c.id">
            <td>{{ c.sort_order }}</td>
            <td><div class="admin-cell-strong">{{ c.label }}</div></td>
            <td><code>{{ c.slug }}</code></td>
            <td>{{ countOf(c.slug) }}</td>
            <td class="col-actions">
              <button class="btn-table" @click="openEdit(c)">Düzenle</button>
              <button class="btn-table danger" @click="onDelete(c)">Sil</button>
            </td>
          </tr>
          <tr v-if="!sorted.length">
            <td colspan="5" style="text-align: center; padding: 24px; color: var(--muted)">
              Henüz kategori yok.
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue';
import { useCategoryStore } from '../../stores/site';
import { useMotorStore } from '../../stores/motors';

const categoryStore = useCategoryStore();
const motorStore = useMotorStore();

const sorted = computed(() => categoryStore.sorted);
const error = ref('');
const saving = ref(false);

const form = reactive({
  show: false,
  id: null,
  label: '',
  sort_order: 9999,
});

onMounted(() => {
  if (!categoryStore.loaded) categoryStore.fetchAll();
  if (!motorStore.loaded) motorStore.fetchAll();
});

function countOf(slug) {
  return motorStore.motors.filter((m) => m.category === slug).length;
}

function openNew() {
  form.show = true;
  form.id = null;
  form.label = '';
  form.sort_order = (sorted.value[sorted.value.length - 1]?.sort_order ?? 0) + 10;
  error.value = '';
}

function openEdit(c) {
  form.show = true;
  form.id = c.id;
  form.label = c.label;
  form.sort_order = c.sort_order ?? 9999;
  error.value = '';
}

async function save() {
  error.value = '';
  saving.value = true;
  try {
    if (form.id) {
      await categoryStore.updateCategory(form.id, {
        label: form.label,
        sort_order: form.sort_order,
      });
    } else {
      await categoryStore.addCategory({
        label: form.label,
        sort_order: form.sort_order,
      });
    }
    form.show = false;
  } catch (e) {
    error.value = e.message || String(e);
  } finally {
    saving.value = false;
  }
}

async function onDelete(c) {
  if (!confirm(`"${c.label}" kategorisini silmek istediğinize emin misiniz?`)) return;
  error.value = '';
  try {
    await categoryStore.deleteCategory(c.id);
  } catch (e) {
    error.value = e.message || String(e);
  }
}
</script>
