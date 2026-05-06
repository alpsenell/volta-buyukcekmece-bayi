<template>
  <div class="admin-page">
    <div class="admin-page-head">
      <div>
        <RouterLink to="/admin" class="breadcrumb">← Motorlar</RouterLink>
        <h1>{{ isEdit ? 'Motoru düzenle' : 'Yeni motor ekle' }}</h1>
      </div>
    </div>

    <form @submit.prevent="save" class="admin-form">
      <div class="admin-form-grid">
        <!-- Sol kolon: alanlar -->
        <div class="admin-form-fields">
          <div class="form-section">
            <h3>Temel bilgiler</h3>
            <label class="field">
              <span>Model adı</span>
              <input type="text" v-model="form.name" required placeholder="Örn: Volta Lit Pro" />
            </label>
            <div class="field-row">
              <label class="field">
                <span>Kategori</span>
                <select v-model="form.category" required>
                  <option v-if="!categoryStore.sorted.length" value="">Kategori yükleniyor...</option>
                  <option
                    v-for="c in categoryStore.sorted"
                    :key="c.id"
                    :value="c.slug"
                  >{{ c.label }}</option>
                </select>
              </label>
              <label class="field">
                <span>Fiyat (₺)</span>
                <input type="number" v-model.number="form.price" required min="0" step="100" />
              </label>
            </div>
            <label class="field">
              <span>Açıklama</span>
              <textarea v-model="form.description" rows="4" placeholder="Modelin kısa tanıtımı..."></textarea>
            </label>
          </div>

          <div class="form-section">
            <h3>Teknik özellikler</h3>
            <div class="field-row">
              <label class="field">
                <span>Menzil (km)</span>
                <input type="number" v-model.number="form.range" min="0" />
              </label>
              <label class="field">
                <span>Maks. hız (km/s)</span>
                <input type="number" v-model.number="form.topSpeed" min="0" />
              </label>
              <label class="field">
                <span>Şarj süresi (saat)</span>
                <input type="number" v-model.number="form.chargeTime" min="0" step="0.5" />
              </label>
            </div>
          </div>

          <div class="form-section">
            <h3>Renkler</h3>
            <div class="color-editor">
              <div
                v-for="(c, i) in form.colors" :key="i"
                class="color-editor-item"
              >
                <input type="color" :value="c" @input="updateColor(i, $event.target.value)" />
                <input type="text" :value="c" @input="updateColor(i, $event.target.value)" placeholder="#000000" />
                <button type="button" class="btn-icon" @click="removeColor(i)" aria-label="Rengi sil">×</button>
              </div>
              <button type="button" class="btn btn-ghost btn-sm" @click="addColor">+ Renk ekle</button>
            </div>
            <small style="color: var(--muted); display: block; margin-top: 8px;">
              Tek renk varsa ürün sayfasında renk seçenekleri bölümü gizlenir.
            </small>
          </div>

          <div class="form-section">
            <h3>Durum</h3>
            <div class="checkbox-row">
              <label class="checkbox">
                <input type="checkbox" v-model="form.inStock" />
                <span>Stokta var</span>
              </label>
              <label class="checkbox">
                <input type="checkbox" v-model="form.featured" />
                <span>Öne çıkar</span>
              </label>
            </div>
          </div>
        </div>

        <!-- Sağ kolon: önizleme + foto -->
        <aside class="admin-form-side">
          <div class="form-section">
            <h3>Fotoğraflar</h3>
            <div class="photo-multi">
              <div class="photo-multi-grid">
                <div
                  v-for="(p, i) in form.photos"
                  :key="`${p}-${i}`"
                  class="photo-multi-item"
                  :class="{ dragging: dragIndex === i }"
                  draggable="true"
                  @dragstart="onPhotoDragStart(i, $event)"
                  @dragover.prevent
                  @drop="onPhotoDrop(i)"
                  :style="{ backgroundImage: `url(${p})` }"
                  :title="i === 0 ? 'Birincil fotoğraf — listede ve kapakta görünür' : `Fotoğraf ${i + 1}`"
                >
                  <span v-if="i === 0" class="photo-multi-primary-tag">Kapak</span>
                  <div class="photo-multi-actions">
                    <button
                      type="button"
                      class="btn-icon"
                      @click.stop="removePhoto(i)"
                      aria-label="Fotoğrafı sil"
                      title="Sil"
                    >×</button>
                  </div>
                </div>

                <label
                  class="photo-add-tile"
                  :class="{ over: dragOver }"
                  @dragover.prevent="dragOver = true"
                  @dragleave="dragOver = false"
                  @drop.prevent="onDrop"
                >
                  <div v-if="uploading">
                    <div class="photo-add-tile-icon">⏳</div>
                    <div>Yükleniyor…</div>
                  </div>
                  <template v-else>
                    <div class="photo-add-tile-icon">+</div>
                    <div>Fotoğraf ekle</div>
                    <small>sürükle-bırak veya tıkla</small>
                  </template>
                  <input
                    type="file"
                    accept="image/*"
                    multiple
                    style="display: none"
                    @change="onFileChange"
                  />
                </label>
              </div>
              <small style="color: var(--muted)">
                Birden fazla fotoğraf yüklerseniz ürün sayfasında karusel görünür. Sürükleyerek sıralayın — ilk fotoğraf kapak görseli olur.
              </small>
            </div>
          </div>

          <div class="form-section">
            <h3>Önizleme</h3>
            <div class="preview-card">
              <MotoCard :motor="previewMotor" />
            </div>
          </div>
        </aside>
      </div>

      <div class="admin-form-actions">
        <p v-if="error" class="form-error">{{ error }}</p>
        <RouterLink to="/admin" class="btn btn-ghost">İptal</RouterLink>
        <button type="submit" class="btn btn-primary btn-lg" :disabled="saving || uploading">
          {{ saving ? 'Kaydediliyor…' : (isEdit ? 'Değişiklikleri kaydet' : 'Motoru ekle') }}
        </button>
      </div>
    </form>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted, watch } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useMotorStore } from '../../stores/motors';
import { useCategoryStore } from '../../stores/site';
import MotoCard from '../../components/MotoCard.vue';

const route = useRoute();
const router = useRouter();
const store = useMotorStore();
const categoryStore = useCategoryStore();

const isEdit = computed(() => !!route.params.id);
const dragOver = ref(false);
const uploading = ref(false);
const saving = ref(false);
const error = ref('');
const dragIndex = ref(null);

const blank = {
  name: '',
  category: '',
  price: 0,
  description: '',
  range: 50,
  topSpeed: 40,
  chargeTime: 4,
  colors: ['#0a0a0a', '#95c121'],
  inStock: true,
  featured: false,
  photos: [],
};

const form = reactive({ ...blank });

onMounted(async () => {
  if (!categoryStore.loaded) await categoryStore.fetchAll();
  // Default category to first one if creating
  if (!isEdit.value && categoryStore.sorted.length && !form.category) {
    form.category = categoryStore.sorted[0].slug;
  }
  if (isEdit.value) {
    if (!store.loaded) await store.fetchAll();
    const existing = store.motors.find((m) => m.id === route.params.id);
    if (existing) {
      Object.assign(form, JSON.parse(JSON.stringify(existing)));
      if (!Array.isArray(form.photos)) form.photos = [];
    }
  }
});

// Re-default category once they load (in case fetchAll resolves after mount)
watch(
  () => categoryStore.sorted.length,
  (len) => {
    if (!isEdit.value && len && !form.category) {
      form.category = categoryStore.sorted[0].slug;
    }
  }
);

const previewMotor = computed(() => ({
  id: 'preview',
  slug: 'preview',
  order: 0,
  ...form,
}));

function addColor() { form.colors.push('#dddddd'); }
function updateColor(i, val) { form.colors[i] = val; }
function removeColor(i) {
  if (form.colors.length > 1) form.colors.splice(i, 1);
}

// ---- Photos ----
function onFileChange(e) {
  const files = Array.from(e.target.files || []);
  if (files.length) handleFiles(files);
  e.target.value = '';
}
function onDrop(e) {
  dragOver.value = false;
  const files = Array.from(e.dataTransfer?.files || []);
  if (files.length) handleFiles(files);
}
async function handleFiles(files) {
  error.value = '';
  uploading.value = true;
  try {
    for (const file of files) {
      if (!file.type.startsWith('image/')) continue;
      const url = await store.uploadPhoto(file);
      if (url) form.photos.push(url);
    }
  } catch (e) {
    error.value = 'Fotoğraf yüklenemedi: ' + (e.message || e);
  } finally {
    uploading.value = false;
  }
}
function removePhoto(i) {
  form.photos.splice(i, 1);
}
function onPhotoDragStart(i, e) {
  dragIndex.value = i;
  e.dataTransfer.effectAllowed = 'move';
}
function onPhotoDrop(i) {
  if (dragIndex.value === null || dragIndex.value === i) {
    dragIndex.value = null;
    return;
  }
  const next = [...form.photos];
  const [moved] = next.splice(dragIndex.value, 1);
  next.splice(i, 0, moved);
  form.photos = next;
  dragIndex.value = null;
}

async function save() {
  error.value = '';
  saving.value = true;
  try {
    if (isEdit.value) {
      await store.updateMotor(route.params.id, { ...form });
    } else {
      await store.addMotor({ ...form });
    }
    router.push('/admin');
  } catch (e) {
    error.value = 'Kaydedilemedi: ' + (e.message || e);
  } finally {
    saving.value = false;
  }
}
</script>
