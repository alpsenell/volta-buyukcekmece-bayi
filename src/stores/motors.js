// Pinia store: motor envanteri (localStorage tabanlı)
import { defineStore } from 'pinia';
import { SEED_MOTORS, slugify } from '../data/seed';

const STORAGE_KEY = 'volta_bayi_motors_v1';

function loadFromStorage() {
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    if (!raw) {
      localStorage.setItem(STORAGE_KEY, JSON.stringify(SEED_MOTORS));
      return [...SEED_MOTORS];
    }
    return JSON.parse(raw);
  } catch (e) {
    return [...SEED_MOTORS];
  }
}

export const useMotorStore = defineStore('motors', {
  state: () => ({
    motors: loadFromStorage(),
  }),

  getters: {
    sorted: (state) => [...state.motors].sort((a, b) => (a.order ?? 999) - (b.order ?? 999)),
    bySlug: (state) => (slug) => state.motors.find((m) => m.slug === slug),
    byCategory: (state) => (cat) => state.motors.filter((m) => m.category === cat),
    featured: (state) => state.motors.filter((m) => m.featured && m.inStock),
    stats: (state) => ({
      total: state.motors.length,
      inStock: state.motors.filter((m) => m.inStock).length,
      featured: state.motors.filter((m) => m.featured).length,
    }),
  },

  actions: {
    persist() {
      try {
        localStorage.setItem(STORAGE_KEY, JSON.stringify(this.motors));
      } catch (e) {
        console.error('Veri kaydedilemedi:', e);
      }
    },

    addMotor(motor) {
      const id = 'm-' + Date.now();
      const slug = slugify(motor.name) || id;
      const newMotor = { id, slug, order: 9999, ...motor };
      this.motors.push(newMotor);
      this.persist();
      return newMotor;
    },

    updateMotor(id, patch) {
      const idx = this.motors.findIndex((m) => m.id === id);
      if (idx >= 0) {
        this.motors[idx] = { ...this.motors[idx], ...patch };
        this.persist();
      }
    },

    deleteMotor(id) {
      this.motors = this.motors.filter((m) => m.id !== id);
      this.persist();
    },

    reorderMotors(nextList) {
      this.motors = nextList.map((m, i) => ({ ...m, order: i + 1 }));
      this.persist();
    },

    resetToSeed() {
      this.motors = [...SEED_MOTORS];
      this.persist();
    },
  },
});

// Admin auth store
export const useAuthStore = defineStore('auth', {
  state: () => ({
    isAuthed: sessionStorage.getItem('volta_admin') === '1',
  }),
  actions: {
    login(password) {
      if (password === 'admin123') {
        this.isAuthed = true;
        sessionStorage.setItem('volta_admin', '1');
        return true;
      }
      return false;
    },
    logout() {
      this.isAuthed = false;
      sessionStorage.removeItem('volta_admin');
    },
  },
});
