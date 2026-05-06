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
                <select v-model="form.category">
                  <option value="scooter">Scooter</option>
                  <option value="atv">ATV</option>
                  <option value="bike">E-Bisiklet</option>
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
            <h3>Fotoğraf</h3>
            <div
              class="photo-drop"
              :class="{ over: dragOver }"
              @dragover.prevent="dragOver = true"
              @dragleave="dragOver = false"
              @drop.prevent="onDrop"
              @click="$refs.fileInput.click()"
            >
              <div v-if="form.photo" class="photo-preview">
                <img :src="form.photo" alt="Motor fotoğrafı" />
                <button type="button" class="btn-icon photo-clear" @click.stop="form.photo = null" aria-label="Fotoğrafı kaldır">×</button>
              </div>
              <div v-else-if="uploading" class="photo-empty">
                <div class="photo-empty-icon">⏳</div>
                <div>Yükleniyor…</div>
              </div>
              <div v-else class="photo-empty">
                <div class="photo-empty-icon">📷</div>
                <div>Fotoğrafı sürükleyip bırakın<br>veya tıklayıp seçin</div>
                <small>Boş bırakırsanız soyut bir görsel kullanılır</small>
              </div>
              <input
                ref="fileInput"
                type="file"
                accept="image/*"
                style="display: none"
                @change="onFileChange"
              />
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
import { ref, reactive, computed, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useMotorStore } from '../../stores/motors';
import MotoCard from '../../components/MotoCard.vue';

const route = useRoute();
const router = useRouter();
const store = useMotorStore();

const isEdit = computed(() => !!route.params.id);
const dragOver = ref(false);
const uploading = ref(false);
const saving = ref(false);
const error = ref('');

const blank = {
  name: '',
  category: 'scooter',
  price: 0,
  description: '',
  range: 50,
  topSpeed: 40,
  chargeTime: 4,
  colors: ['#0a0a0a', '#95c121'],
  inStock: true,
  featured: false,
  photo: null,
};

const form = reactive({ ...blank });

onMounted(async () => {
  if (isEdit.value) {
    if (!store.loaded) await store.fetchAll();
    const existing = store.motors.find((m) => m.id === route.params.id);
    if (existing) {
      Object.assign(form, JSON.parse(JSON.stringify(existing)));
    }
  }
});

const previewMotor = computed(() => ({
  id: 'preview',
  slug: 'preview',
  order: 0,
  ...form,
}));

function addColor() {
  form.colors.push('#dddddd');
}
function updateColor(i, val) {
  form.colors[i] = val;
}
function removeColor(i) {
  if (form.colors.length > 1) form.colors.splice(i, 1);
}

function onFileChange(e) {
  const file = e.target.files?.[0];
  if (file) handleFile(file);
}
function onDrop(e) {
  dragOver.value = false;
  const file = e.dataTransfer?.files?.[0];
  if (file) handleFile(file);
}
async function handleFile(file) {
  if (!file.type.startsWith('image/')) {
    error.value = 'Lütfen bir görsel dosyası seçin.';
    return;
  }
  error.value = '';
  uploading.value = true;
  try {
    const url = await store.uploadPhoto(file);
    form.photo = url;
  } catch (e) {
    error.value = 'Fotoğraf yüklenemedi: ' + (e.message || e);
  } finally {
    uploading.value = false;
  }
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
