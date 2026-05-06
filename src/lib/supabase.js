import { createClient } from '@supabase/supabase-js';

const url = import.meta.env.VITE_SUPABASE_URL;
const anonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

if (!url || !anonKey) {
  console.error(
    '[supabase] VITE_SUPABASE_URL ve/veya VITE_SUPABASE_ANON_KEY tanımlı değil. .env.local oluşturun.'
  );
}

export const supabase = createClient(url ?? '', anonKey ?? '', {
  auth: {
    persistSession: true,
    autoRefreshToken: true,
    detectSessionInUrl: false,
  },
});

export const PHOTOS_BUCKET = 'motor-photos';
export const SITE_ASSETS_BUCKET = 'site-assets';
