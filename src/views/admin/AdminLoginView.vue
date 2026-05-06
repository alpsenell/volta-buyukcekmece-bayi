<template>
  <main class="admin-login">
    <div class="admin-login-card">
      <div class="brand">
        <span class="brand-mark" aria-hidden="true">
          <svg viewBox="0 0 32 32" width="28" height="28">
            <path d="M 8 4 L 16 28 L 24 4 L 19 4 L 16 18 L 13 4 Z" fill="currentColor" />
          </svg>
        </span>
        <span class="brand-text">
          <span class="brand-name">VOLTA</span>
          <span class="brand-sub">Yönetim Paneli</span>
        </span>
      </div>
      <h1>Bayi Yönetim Paneli</h1>
      <p class="admin-login-lead">Yönetici e-posta ve şifresi ile giriş yapın.</p>
      <form @submit.prevent="onSubmit" class="admin-login-form">
        <input
          type="email"
          v-model="email"
          placeholder="ornek@volta-bayi.com"
          autocomplete="email"
          required
          autofocus
        />
        <input
          type="password"
          v-model="password"
          placeholder="Şifre"
          autocomplete="current-password"
          required
        />
        <button type="submit" class="btn btn-primary btn-lg" :disabled="auth.loading">
          {{ auth.loading ? 'Giriş yapılıyor…' : 'Giriş yap' }}
        </button>
        <p v-if="error" class="form-error">{{ error }}</p>
      </form>
      <RouterLink to="/" class="btn-link">← Ana siteye dön</RouterLink>
    </div>
  </main>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { useAuthStore } from '../../stores/motors';

const email = ref('');
const password = ref('');
const error = ref('');
const auth = useAuthStore();
const router = useRouter();

async function onSubmit() {
  error.value = '';
  const ok = await auth.login(email.value.trim(), password.value);
  if (ok) {
    router.push('/admin');
  } else {
    error.value = auth.error || 'Giriş başarısız. E-posta veya şifre hatalı.';
  }
}
</script>
