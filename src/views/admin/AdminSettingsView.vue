<template>
  <div class="admin-page">
    <div class="admin-page-head">
      <div>
        <h1>Site ayarları</h1>
        <p class="admin-page-lead">
          Logo, iletişim bilgileri ve ana sayfa hero banner — site genelinde görünen bilgiler.
        </p>
      </div>
    </div>

    <p v-if="error" class="form-error">{{ error }}</p>
    <p v-if="savedFlash" class="form-sent">✓ Ayarlar kaydedildi.</p>

    <form @submit.prevent="onSave" class="admin-form">
      <div class="admin-settings-grid">
        <!-- LOGO -->
        <div class="admin-settings-section">
          <h3>Logo</h3>
          <div class="admin-asset-uploader">
            <div
              class="admin-asset-preview"
              :class="{ empty: !form.logo_url }"
              :style="form.logo_url ? { backgroundImage: `url(${form.logo_url})` } : {}"
            >
              <span v-if="!form.logo_url">🏷</span>
            </div>
            <div style="display: flex; flex-direction: column; gap: 8px;">
              <label class="btn btn-ghost btn-sm" :class="{ disabled: uploadingLogo }" style="cursor: pointer; display: inline-flex; align-items: center;">
                {{ uploadingLogo ? 'Yükleniyor…' : (form.logo_url ? 'Logoyu değiştir' : 'Logo yükle') }}
                <input
                  type="file"
                  accept="image/*"
                  style="display: none"
                  @change="onLogoChange"
                  :disabled="uploadingLogo"
                />
              </label>
              <button
                v-if="form.logo_url"
                type="button"
                class="btn-link"
                @click="form.logo_url = null"
                style="text-align: left; color: var(--muted)"
              >Logoyu kaldır</button>
            </div>
          </div>
          <small style="display: block; color: var(--muted); margin-top: 12px">
            Logo yüklenmezse VOLTA metin işareti gösterilir.
          </small>
        </div>

        <!-- HERO -->
        <div class="admin-settings-section">
          <h3>Hero banner (ana sayfa)</h3>
          <label class="field">
            <span>Başlık</span>
            <input type="text" v-model="form.hero_title" placeholder="Örn: Şehir senin, enerji bizden." />
          </label>
          <label class="field">
            <span>Alt başlık</span>
            <textarea v-model="form.hero_subtitle" rows="3" placeholder="Hero bölümünde gösterilecek kısa açıklama"></textarea>
          </label>
          <div class="field-row">
            <label class="field">
              <span>Buton metni</span>
              <input type="text" v-model="form.hero_cta_label" placeholder="Tüm modelleri gör" />
            </label>
            <label class="field">
              <span>Buton bağlantısı</span>
              <input type="text" v-model="form.hero_cta_href" placeholder="/katalog" />
            </label>
          </div>
          <div style="margin-top: 12px">
            <span class="field-label" style="display: block; font-size: 13px; color: var(--ink-2); margin-bottom: 8px;">Banner görseli (opsiyonel)</span>
            <div class="admin-asset-uploader">
              <div
                class="admin-asset-preview"
                :class="{ empty: !form.hero_image_url }"
                :style="form.hero_image_url ? { backgroundImage: `url(${form.hero_image_url})` } : {}"
              >
                <span v-if="!form.hero_image_url">🖼</span>
              </div>
              <div style="display: flex; flex-direction: column; gap: 8px;">
                <label class="btn btn-ghost btn-sm" style="cursor: pointer; display: inline-flex; align-items: center;">
                  {{ uploadingHero ? 'Yükleniyor…' : (form.hero_image_url ? 'Görseli değiştir' : 'Banner yükle') }}
                  <input
                    type="file"
                    accept="image/*"
                    style="display: none"
                    @change="onHeroChange"
                    :disabled="uploadingHero"
                  />
                </label>
                <button
                  v-if="form.hero_image_url"
                  type="button"
                  class="btn-link"
                  @click="form.hero_image_url = null"
                  style="text-align: left; color: var(--muted)"
                >Görseli kaldır</button>
              </div>
            </div>
            <small style="display: block; color: var(--muted); margin-top: 8px">
              Banner görseli yüklenirse hero bölümü tam genişlik karanlık overlay'lı bir banner olur. Yüklenmezse öne çıkan motor kartlarıyla split tasarım gösterilir.
            </small>
          </div>
        </div>

        <!-- ADRES + İLETİŞİM -->
        <div class="admin-settings-section">
          <h3>İletişim bilgileri</h3>
          <label class="field">
            <span>Adres</span>
            <textarea v-model="form.address" rows="3" placeholder="Atatürk Cd. No: 123\nMimarsinan / Büyükçekmece\nİstanbul"></textarea>
          </label>
          <div class="field-row">
            <label class="field">
              <span>Telefon</span>
              <input type="text" v-model="form.phone" placeholder="0212 000 00 00" />
            </label>
            <label class="field">
              <span>E-posta</span>
              <input type="email" v-model="form.email" placeholder="info@volta-bayi.com" />
            </label>
          </div>
          <label class="field">
            <span>Çalışma saatleri</span>
            <textarea v-model="form.working_hours" rows="2" placeholder="Pzt-Cum 09:00-19:00\nCmt 10:00-18:00"></textarea>
          </label>
          <div class="field-row">
            <label class="field">
              <span>Konum enlem (lat)</span>
              <input type="number" step="any" v-model.number="form.map_lat" placeholder="41.0210" />
            </label>
            <label class="field">
              <span>Konum boylam (lng)</span>
              <input type="number" step="any" v-model.number="form.map_lng" placeholder="28.5946" />
            </label>
          </div>
          <small style="color: var(--muted)">
            Enlem/boylam girilirse iletişim sayfasında gerçek harita gösterilir.
          </small>
        </div>

        <!-- SOSYAL MEDYA -->
        <div class="admin-settings-section">
          <h3>Sosyal medya</h3>
          <label class="field">
            <span>Instagram URL</span>
            <input type="url" v-model="form.social_instagram" placeholder="https://instagram.com/volta-buyukcekmece" />
          </label>
          <label class="field">
            <span>Facebook URL</span>
            <input type="url" v-model="form.social_facebook" placeholder="https://facebook.com/volta-buyukcekmece" />
          </label>
          <label class="field">
            <span>YouTube URL</span>
            <input type="url" v-model="form.social_youtube" placeholder="https://youtube.com/@volta-buyukcekmece" />
          </label>
        </div>
      </div>

      <div class="admin-form-actions" style="margin-top: 24px">
        <button type="submit" class="btn btn-primary btn-lg" :disabled="saving || uploadingLogo || uploadingHero">
          {{ saving ? 'Kaydediliyor…' : 'Ayarları kaydet' }}
        </button>
      </div>
    </form>
  </div>
</template>

<script setup>
import { reactive, ref, onMounted, watch } from 'vue';
import { useSettingsStore } from '../../stores/site';

const settingsStore = useSettingsStore();
const saving = ref(false);
const uploadingLogo = ref(false);
const uploadingHero = ref(false);
const error = ref('');
const savedFlash = ref(false);

const form = reactive({
  logo_url: null,
  address: '',
  phone: '',
  email: '',
  working_hours: '',
  map_lat: null,
  map_lng: null,
  hero_title: '',
  hero_subtitle: '',
  hero_cta_label: '',
  hero_cta_href: '/katalog',
  hero_image_url: null,
  social_facebook: '',
  social_instagram: '',
  social_youtube: '',
});

function loadFromStore() {
  Object.assign(form, settingsStore.settings);
}

onMounted(async () => {
  if (!settingsStore.loaded) await settingsStore.fetch();
  loadFromStore();
});

watch(() => settingsStore.loaded, (loaded) => {
  if (loaded) loadFromStore();
});

async function onLogoChange(e) {
  const file = e.target.files?.[0];
  e.target.value = '';
  if (!file) return;
  error.value = '';
  uploadingLogo.value = true;
  try {
    const url = await settingsStore.uploadAsset(file, 'logo');
    form.logo_url = url;
  } catch (err) {
    error.value = 'Logo yüklenemedi: ' + (err.message || err);
  } finally {
    uploadingLogo.value = false;
  }
}

async function onHeroChange(e) {
  const file = e.target.files?.[0];
  e.target.value = '';
  if (!file) return;
  error.value = '';
  uploadingHero.value = true;
  try {
    const url = await settingsStore.uploadAsset(file, 'hero');
    form.hero_image_url = url;
  } catch (err) {
    error.value = 'Banner yüklenemedi: ' + (err.message || err);
  } finally {
    uploadingHero.value = false;
  }
}

async function onSave() {
  error.value = '';
  savedFlash.value = false;
  saving.value = true;
  try {
    await settingsStore.save({ ...form });
    savedFlash.value = true;
    setTimeout(() => { savedFlash.value = false; }, 3000);
  } catch (e) {
    error.value = 'Kaydedilemedi: ' + (e.message || e);
  } finally {
    saving.value = false;
  }
}
</script>
