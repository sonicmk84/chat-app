import axios from 'axios';
import Echo from 'laravel-echo';
import Pusher from 'pusher-js'; // Reverb uses Pusher protocol
window.axios = axios;
window.Pusher = Pusher;

window.axios.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';

/**
 * Echo exposes an expressive API for subscribing to channels and listening
 * for events that are broadcast by Laravel. Echo and event broadcasting
 * allow your team to quickly build robust real-time web applications.
 */

import './echo';

const isDev = import.meta.env.DEV;

window.Echo = new Echo({
  broadcaster: 'reverb',
  key: import.meta.env.VITE_REVERB_APP_KEY ?? 'local',
  wsHost: import.meta.env.VITE_REVERB_HOST ?? 'localhost',
  wsPort: Number(import.meta.env.VITE_REVERB_PORT ?? 6001),
  wssPort: Number(import.meta.env.VITE_REVERB_PORT ?? 6001),
  forceTLS: !isDev && (import.meta.env.VITE_REVERB_SCHEME ?? 'http') === 'https',
  enabledTransports: isDev ? ['ws'] : ['ws','wss'],
});