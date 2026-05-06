// Tüm site verisi: motor seed'leri ve sabitler

export const SEED_MOTORS = [
  {
    id: 'm-001', slug: 'lit', name: 'Volta Lit', category: 'scooter',
    price: 64900, range: 60, topSpeed: 45, chargeTime: 4,
    colors: ['#0a0a0a', '#dc2626', '#f5f5f5'],
    inStock: true, featured: true, order: 1,
    description: 'Şehir içi günlük kullanım için ideal, hafif ve çevik elektrikli scooter. Kompakt gövde, sessiz motor.',
    photo: null,
  },
  {
    id: 'm-002', slug: 'rks-max', name: 'Volta RKS Max', category: 'scooter',
    price: 89900, range: 110, topSpeed: 70, chargeTime: 6,
    colors: ['#0a0a0a', '#1d4ed8', '#95c121'],
    inStock: true, featured: true, order: 2,
    description: 'Uzun menzilli sport scooter. İş ve uzun yol için güçlü performans, gelişmiş süspansiyon.',
    photo: null,
  },
  {
    id: 'm-003', slug: 'cyclone', name: 'Volta Cyclone', category: 'scooter',
    price: 109900, range: 140, topSpeed: 90, chargeTime: 7,
    colors: ['#0a0a0a', '#dc2626'],
    inStock: false, featured: true, order: 3,
    description: 'Üst segment elektrikli motosiklet. ABS, dijital gösterge, akıllı bağlantı özellikleri.',
    photo: null,
  },
  {
    id: 'm-004', slug: 'atv-pro', name: 'Volta ATV Pro', category: 'atv',
    price: 159900, range: 80, topSpeed: 55, chargeTime: 8,
    colors: ['#0a0a0a', '#16a34a', '#ea580c'],
    inStock: true, featured: false, order: 4,
    description: 'Arazi ve çiftlik kullanımı için tasarlanmış 4 tekerlekli elektrikli ATV. Yüksek tork, dayanıklı şasi.',
    photo: null,
  },
  {
    id: 'm-005', slug: 'atv-mini', name: 'Volta ATV Mini', category: 'atv',
    price: 79900, range: 50, topSpeed: 35, chargeTime: 5,
    colors: ['#dc2626', '#facc15', '#0a0a0a'],
    inStock: true, featured: false, order: 5,
    description: 'Genç sürücüler ve hobi kullanıcıları için kompakt elektrikli ATV. Güvenli ve eğlenceli.',
    photo: null,
  },
  {
    id: 'm-006', slug: 'e-bike-city', name: 'Volta E-Bike City', category: 'bike',
    price: 34900, range: 70, topSpeed: 25, chargeTime: 4,
    colors: ['#0a0a0a', '#f5f5f5', '#95c121'],
    inStock: true, featured: true, order: 6,
    description: 'Şehir içi bisiklet kullanıcıları için pedal destekli elektrikli bisiklet. Şık tasarım, uzun menzil.',
    photo: null,
  },
  {
    id: 'm-007', slug: 'e-bike-trail', name: 'Volta E-Bike Trail', category: 'bike',
    price: 49900, range: 90, topSpeed: 32, chargeTime: 5,
    colors: ['#0a0a0a', '#16a34a'],
    inStock: true, featured: false, order: 7,
    description: 'Off-road ve dağ kullanımı için dayanıklı elektrikli bisiklet. Geniş tekerler, çift süspansiyon.',
    photo: null,
  },
  {
    id: 'm-008', slug: 'urban-x', name: 'Volta Urban X', category: 'scooter',
    price: 74900, range: 75, topSpeed: 50, chargeTime: 5,
    colors: ['#0a0a0a', '#f5f5f5'],
    inStock: true, featured: false, order: 8,
    description: 'Modern şehirli için minimal tasarım. Akıllı kilit, GPS takip, mobil uygulama desteği.',
    photo: null,
  },
];

export const CATEGORY_LABELS = {
  scooter: 'Scooter',
  atv: 'ATV',
  bike: 'E-Bisiklet',
};

export function formatPrice(n) {
  return new Intl.NumberFormat('tr-TR').format(n) + ' ₺';
}

export function slugify(s) {
  return s.toLowerCase()
    .replace(/ç/g, 'c').replace(/ğ/g, 'g').replace(/ı/g, 'i')
    .replace(/ö/g, 'o').replace(/ş/g, 's').replace(/ü/g, 'u')
    .replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '');
}
