// Disinstalla il vecchio service worker e cancella tutte le cache
self.addEventListener('install', () => self.skipWaiting());
self.addEventListener('activate', e => {
  e.waitUntil(
    caches.keys().then(ks => Promise.all(ks.map(k => caches.delete(k))))
    .then(() => self.clients.claim())
    .then(() => self.clients.matchAll().then(cs => cs.forEach(c => c.navigate(c.url))))
  );
});
