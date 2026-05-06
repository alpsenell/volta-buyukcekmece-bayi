<template>
  <main class="contact-page">
    <section class="page-head container">
      <div class="section-eyebrow">İletişim</div>
      <h1 class="page-title">Bize ulaşın.</h1>
      <p class="page-lead">
        Showroom'umuzu ziyaret edin, telefon edin ya da formu doldurun — en kısa sürede dönüş yapalım.
      </p>
    </section>

    <section class="container contact-grid">
      <div class="contact-info">
        <div class="contact-item">
          <div class="contact-label">Adres</div>
          <div class="contact-value">
            Atatürk Caddesi No: 123<br>
            Mimarsinan / Büyükçekmece<br>
            İstanbul
          </div>
        </div>
        <div class="contact-item">
          <div class="contact-label">Telefon</div>
          <div class="contact-value"><a href="tel:+902120000000">0212 000 00 00</a></div>
        </div>
        <div class="contact-item">
          <div class="contact-label">E-posta</div>
          <div class="contact-value"><a href="mailto:info@voltabuyukcekmece.com">info@voltabuyukcekmece.com</a></div>
        </div>
        <div class="contact-item">
          <div class="contact-label">Çalışma saatleri</div>
          <div class="contact-value">
            Pazartesi–Cuma · 09:00–19:00<br>
            Cumartesi · 10:00–18:00<br>
            Pazar · Kapalı
          </div>
        </div>
      </div>

      <div class="contact-map">
        <div class="map-placeholder">
          <svg viewBox="0 0 600 400" width="100%" height="100%" preserveAspectRatio="xMidYMid slice">
            <defs>
              <pattern id="map-grid" width="40" height="40" patternUnits="userSpaceOnUse">
                <path d="M 40 0 L 0 0 0 40" fill="none" stroke="#d6d3d1" stroke-width="1"/>
              </pattern>
            </defs>
            <rect width="600" height="400" fill="#f5f5f4"/>
            <rect width="600" height="400" fill="url(#map-grid)"/>
            <path d="M 0 200 Q 200 180, 350 220 T 600 200" stroke="#a8a29e" stroke-width="14" fill="none"/>
            <path d="M 0 200 Q 200 180, 350 220 T 600 200" stroke="#fff" stroke-width="10" fill="none"/>
            <path d="M 280 0 L 320 400" stroke="#a8a29e" stroke-width="10" fill="none"/>
            <path d="M 280 0 L 320 400" stroke="#fff" stroke-width="6" fill="none"/>
            <rect x="80" y="60" width="140" height="90" fill="#dcfce7" opacity="0.7" rx="6"/>
            <rect x="420" y="240" width="120" height="100" fill="#dcfce7" opacity="0.7" rx="6"/>
            <path d="M 0 360 L 600 380 L 600 400 L 0 400 Z" fill="#bae6fd" opacity="0.5"/>
            <g transform="translate(310, 200)">
              <circle r="28" fill="#95c121" opacity="0.25"/>
              <circle r="14" fill="#95c121"/>
              <circle r="6" fill="#fff"/>
            </g>
          </svg>
          <div class="map-tag">
            <strong>Volta Büyükçekmece Bayi</strong>
            <span>Atatürk Cd. No:123</span>
          </div>
        </div>
      </div>
    </section>

    <section class="container contact-form-section">
      <div class="contact-form-wrap">
        <h2 class="section-title">Bize bir mesaj bırakın</h2>
        <form @submit.prevent="submit" class="contact-form">
          <label>
            <span>Ad Soyad</span>
            <input type="text" required v-model="form.name" placeholder="Adınız Soyadınız" />
          </label>
          <label>
            <span>Telefon</span>
            <input type="tel" required v-model="form.phone" placeholder="0(5xx) xxx xx xx" />
          </label>
          <label class="full">
            <span>Mesajınız</span>
            <textarea rows="5" required v-model="form.message" placeholder="İlgilendiğiniz model, sorunuz..."></textarea>
          </label>
          <div class="form-bottom">
            <button type="submit" class="btn btn-primary btn-lg">Gönder</button>
            <span v-if="sent" class="form-sent">✓ Mesajınız alındı, en kısa sürede dönüş yapacağız.</span>
          </div>
        </form>
      </div>
    </section>
  </main>
</template>

<script setup>
import { reactive, ref } from 'vue';

const form = reactive({ name: '', phone: '', message: '' });
const sent = ref(false);

function submit() {
  sent.value = true;
  setTimeout(() => { sent.value = false; }, 4000);
  form.name = '';
  form.phone = '';
  form.message = '';
}
</script>
