// Recently viewed products — client-only, persisted in localStorage.
import { defineStore } from 'pinia';

const STORAGE_KEY = 'volta_recent_v1';
const MAX_ITEMS = 8;

function load() {
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    if (!raw) return [];
    const arr = JSON.parse(raw);
    return Array.isArray(arr) ? arr.filter((x) => typeof x === 'string') : [];
  } catch {
    return [];
  }
}

function persist(ids) {
  try {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(ids));
  } catch {
    /* quota, private mode — ignore */
  }
}

export const useRecentStore = defineStore('recent', {
  state: () => ({
    ids: load(),
  }),

  actions: {
    track(id) {
      if (!id) return;
      this.ids = [id, ...this.ids.filter((x) => x !== id)].slice(0, MAX_ITEMS);
      persist(this.ids);
    },

    clear() {
      this.ids = [];
      try { localStorage.removeItem(STORAGE_KEY); } catch {}
    },
  },
});
