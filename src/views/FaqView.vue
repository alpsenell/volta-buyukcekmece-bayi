<template>
  <main class="faq-page">
    <section class="page-head container">
      <div class="section-eyebrow">Sıkça sorulan sorular</div>
      <h1 class="page-title">Yardım & destek</h1>
      <p class="page-lead">
        Showroom, garanti, servis ve ürünlerimiz hakkında en çok sorulan sorular ve cevapları.
      </p>
    </section>

    <section class="container faq-section">
      <p v-if="store.loading && !store.faqs.length" class="empty">Yükleniyor…</p>
      <p v-else-if="!visible.length" class="empty">Henüz soru eklenmemiş.</p>

      <ul v-else class="faq-list">
        <li
          v-for="(f, i) in visible"
          :key="f.id"
          class="faq-item"
          :class="{ open: openIndex === i }"
        >
          <button
            type="button"
            class="faq-question"
            @click="toggle(i)"
            :aria-expanded="openIndex === i"
            :aria-controls="`faq-answer-${i}`"
          >
            <span>{{ f.question }}</span>
            <span class="faq-chevron" aria-hidden="true">{{ openIndex === i ? '−' : '+' }}</span>
          </button>
          <div
            v-show="openIndex === i"
            :id="`faq-answer-${i}`"
            class="faq-answer"
          >{{ f.answer }}</div>
        </li>
      </ul>

      <div class="faq-cta-card">
        <div>
          <h3>Sorunuz burada yok mu?</h3>
          <p>Bayimizi arayın ya da iletişim formunu doldurun, hemen yardımcı olalım.</p>
        </div>
        <RouterLink to="/iletisim" class="btn btn-primary btn-lg">İletişime geç →</RouterLink>
      </div>
    </section>
  </main>
</template>

<script setup>
import { ref, computed, onMounted, watchEffect } from 'vue';
import { useFaqStore } from '../stores/site';

const store = useFaqStore();
const openIndex = ref(0);

const visible = computed(() => store.visibleSorted);

onMounted(() => {
  if (!store.loaded) store.fetchAll();
});

function toggle(i) {
  openIndex.value = openIndex.value === i ? -1 : i;
}

// FAQPage JSON-LD for rich results.
let jsonLdEl = null;
watchEffect(() => {
  if (typeof document === 'undefined') return;
  const items = visible.value;
  if (!items.length) {
    if (jsonLdEl) {
      jsonLdEl.remove();
      jsonLdEl = null;
    }
    return;
  }
  const ld = {
    '@context': 'https://schema.org',
    '@type': 'FAQPage',
    mainEntity: items.map((f) => ({
      '@type': 'Question',
      name: f.question,
      acceptedAnswer: {
        '@type': 'Answer',
        text: f.answer,
      },
    })),
  };
  if (!jsonLdEl) {
    jsonLdEl = document.createElement('script');
    jsonLdEl.setAttribute('type', 'application/ld+json');
    jsonLdEl.setAttribute('data-faq-jsonld', '');
    document.head.appendChild(jsonLdEl);
  }
  jsonLdEl.textContent = JSON.stringify(ld);
});
</script>
