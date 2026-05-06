<template>
  <footer class="site-footer">
    <div class="container footer-inner">
      <div class="footer-brand">
        <div class="brand">
          <span class="brand-mark" aria-hidden="true">
            <svg viewBox="0 0 32 32" width="28" height="28">
              <path d="M 8 4 L 16 28 L 24 4 L 19 4 L 16 18 L 13 4 Z" fill="currentColor" />
            </svg>
          </span>
          <span class="brand-text">
            <span class="brand-name">VOLTA</span>
            <span class="brand-sub">Büyükçekmece Bayi</span>
          </span>
        </div>
        <p class="footer-copy">
          Volta Motor yetkili satış ve servis bayisi. Şehir içi ulaşımdan arazi kullanımına,
          ihtiyacınıza uygun elektrikli aracı keşfedin.
        </p>
      </div>

      <div class="footer-cols">
        <div>
          <h4>Site</h4>
          <RouterLink to="/">Ana Sayfa</RouterLink>
          <RouterLink to="/katalog">Motorlar</RouterLink>
          <RouterLink to="/hakkimizda">Hakkımızda</RouterLink>
          <RouterLink to="/iletisim">İletişim</RouterLink>
        </div>
        <div>
          <h4>Kategoriler</h4>
          <RouterLink to="/katalog?cat=scooter">Scooter</RouterLink>
          <RouterLink to="/katalog?cat=atv">ATV</RouterLink>
          <RouterLink to="/katalog?cat=bike">E-Bisiklet</RouterLink>
        </div>
        <div>
          <h4>İletişim</h4>
          <p>Atatürk Cad. No: 123<br>Büyükçekmece / İstanbul</p>
          <p>0212 000 00 00<br>info@voltabuyukcekmece.com</p>
        </div>
      </div>
    </div>
    <div class="footer-bottom container">
      <span>© 2026 Volta Büyükçekmece Bayi · Bu site bir prototip tasarımıdır</span>
      <span class="footer-meta">Pazartesi–Cumartesi 09:00–19:00</span>
    </div>
  </footer>
</template>
