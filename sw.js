const CACHE_NAME = 'souljournal-v1';

self.addEventListener('install', (e) => {
  self.skipWaiting();
});

self.addEventListener('activate', (e) => {
  e.waitUntil(clients.claim());
});

self.addEventListener('fetch', (e) => {
  // Let network requests pass through with network-first fallback
  e.respondWith(
    fetch(e.request).catch(() => caches.match(e.request))
  );
});
