
(function() {
    'use strict';

    // --- Stub out analytics globals ---
    window.ga   = function(){};
    window.gtag = function(){};
    window._gaq = { push: function(){} };
    window.fbq  = function(){};
    window._fbq = function(){};

    // Use a Set for O(1) highly optimized lookups instead of Array.some()
    const BLOCKED_HOSTS = new Set([
        'google-analytics.com', 'googletagmanager.com', 'googletagservices.com',
        'googleadservices.com', 'doubleclick.net', '2mdn.net',
        'facebook.com', 'connect.facebook.net',
        'taboola.com', 'outbrain.com', 'criteo.com',
        'rubiconproject.com', 'amazon-adsystem.com', 'scorecardresearch.com',
        'hotjar.com', 'clarity.ms', 'mixpanel.com',
        'amplitude.com', 'segment.io', 'sentry.io',
        'analytics.twitter.com', 'bat.bing.com',
    ]);

    const BLOCKED_PATHS = ['/ad/', '/ads/', '/advert/', '/adserver/', '/track/', '/tracker/', '/pixel/'];

    function shouldBlock(url) {
        try {
            const u = new URL(url, location.href);
            let h = u.hostname;
            
            // Check exact host
            if (BLOCKED_HOSTS.has(h)) return true;
            
            // Check domain base (e.g. sub.google-analytics.com -> google-analytics.com)
            let parts = h.split('.');
            if (parts.length > 2) {
                let domain = parts[parts.length - 2] + '.' + parts[parts.length - 1];
                if (BLOCKED_HOSTS.has(domain)) return true;
            }

            // Check paths using traditional loop (faster than .some)
            let p = u.pathname;
            for (let i = 0; i < BLOCKED_PATHS.length; i++) {
                if (p.startsWith(BLOCKED_PATHS[i])) return true;
            }
        } catch (_) {}
        return false;
    }

    // --- Block fetch() ---
    const _origFetch = window.fetch.bind(window);
    window.fetch = function(input, init) {
        const url = (typeof input === 'string') ? input : input.url;
        if (shouldBlock(url)) {
            console.debug('[ubrowser] blocked fetch:', url);
            return Promise.reject(new TypeError('Network request blocked by ubrowser'));
        }
        return _origFetch(input, init);
    };

    // --- Block XMLHttpRequest ---
    const _origOpen = XMLHttpRequest.prototype.open;
    XMLHttpRequest.prototype.open = function(method, url, ...rest) {
        if (shouldBlock(url)) {
            console.debug('[ubrowser] blocked XHR:', url);
            this._ubrowserBlocked = true;
        }
        return _origOpen.call(this, method, url, ...rest);
    };
    const _origSend = XMLHttpRequest.prototype.send;
    XMLHttpRequest.prototype.send = function(...args) {
        if (this._ubrowserBlocked) return;
        return _origSend.apply(this, args);
    };

    // --- Block navigator.sendBeacon ---
    const _origBeacon = navigator.sendBeacon.bind(navigator);
    navigator.sendBeacon = function(url, data) {
        if (shouldBlock(url)) {
            console.debug('[ubrowser] blocked beacon:', url);
            return true;
        }
        return _origBeacon(url, data);
    };
})();
