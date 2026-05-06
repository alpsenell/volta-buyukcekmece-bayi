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
      <p class="admin-login-lead">Devam etmek için yönetici şifresini girin.</p>
      <form @submit.prevent="onSubmit" class="admin-login-form">
        <input
          type="password"
          v-model="password"
          placeholder="Yönetici şifresi"
          autofocus
        />
        <button type="submit" class="btn btn-primary btn-lg">Giriş yap</button>
        <p v-if="error" class="form-error">{{ error }}</p>
      </form>
      <div class="admin-login-hint">
        <strong>Demo şifre:</strong> <code>admin123</code>
      </div>
      <RouterLink to="/" class="btn-link">← Ana siteye dön</RouterLink>
    </div>
  </main>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { useAuthStore } from '../../stores/motors';

const password = ref('');
const error = ref('');
const auth = useAuthStore();
const router = useRouter();

function onSubmit() {
  if (auth.login(password.value)) {
    router.push('/admin');
  } else {
    error.value = 'Şifre hatalı. Demo şifre: admin123';
  }
}
</script>
