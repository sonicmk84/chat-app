import './bootstrap';

import Alpine from 'alpinejs';

window.Alpine = Alpine;

Alpine.start();

document.addEventListener('DOMContentLoaded', () => {
  const messagesEl = document.getElementById('messages');
  const form = document.getElementById('chat-form');
  const content = document.getElementById('content');

  // Listen to the public "chat" channel
  window.Echo.channel('chat').listen('.MessageSent', (e) => {
    appendMessage(e.user.name, e.content);
  });

  form?.addEventListener('submit', async (ev) => {
    ev.preventDefault();
    const text = content.value.trim();
    if (!text) return;

    const res = await fetch('/messages', {
      method: 'POST',
      headers: {
        'X-CSRF-TOKEN': document.querySelector('meta[name=csrf-token]').getAttribute('content'),
        'X-Requested-With': 'XMLHttpRequest',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: JSON.stringify({ content: text })
    });

    if (!res.ok) {
      console.error('POST /messages failed', res.status, await res.text());
      return;
    }

    if (res.ok) {
      content.value = '';
    }
  });

  function appendMessage(name, text) {
    const div = document.createElement('div');
    div.className = 'text-sm';
    div.innerHTML = `<span class="font-semibold">${name}:</span> <span>${text}</span>`;
    messagesEl.appendChild(div);
    messagesEl.scrollTop = messagesEl.scrollHeight;
  }
});