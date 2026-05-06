import { createApp } from 'vue';
import { createPinia } from 'pinia';
import App from './App.vue';
import router from './router';
import { useAuthStore } from './stores/motors';
import './styles/main.css';

const app = createApp(App);
const pinia = createPinia();
app.use(pinia);

// Bootstrap auth (read existing session from storage + subscribe to changes)
// before mounting so the admin route guard sees the correct state.
async function bootstrap() {
  const auth = useAuthStore(pinia);
  await auth.init();
  app.use(router);
  app.mount('#app');
}

bootstrap();
