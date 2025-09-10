import Echo from "laravel-echo";

import Pusher from "pusher-js";
window.Pusher = Pusher;

const isDev = import.meta.env.DEV;

window.Echo = new Echo({
    broadcaster: "reverb",
    key: import.meta.env.VITE_REVERB_APP_KEY ?? "local",
    wsHost: import.meta.env.VITE_REVERB_HOST ?? "127.0.0.1",
    wsPort: Number(import.meta.env.VITE_REVERB_PORT ?? 6001),
    wssPort: Number(import.meta.env.VITE_REVERB_PORT ?? 6001),
    forceTLS: !isDev && (import.meta.env.VITE_REVERB_SCHEME ?? "http") === "https",
    enabledTransports: isDev ? ["ws"] : ["ws", "wss"],
});
