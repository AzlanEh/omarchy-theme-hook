/**
 * @name Theme Hot Reload
 * @description Automatically reloads the theme when the CSS file changes
 * @version 1.0.0
 * @author omarchy
 */

class ThemeHotReload {
    constructor() {
        this.themePath = '/home/azlan/.config/stremio-enhanced/themes/omarchy-dynamic.theme.css';
        this.checkInterval = 2000; // Check every 2 seconds
        this.lastModified = null;
        this.lastSize = null;
        this.isReloading = false;
        this.retryCount = 0;
        this.maxRetries = 3;
        this.init();
    }

    init() {
        console.log('[ThemeHotReload] Initializing hot reload for:', this.themePath);
        this.injectStyles();
        this.setupThemeChangeListener();
        this.startMonitoring();
        this.setupVisibilityListener();
        this.showStatus('Hot reload active');

        // Force an initial check after plugin loads
        setTimeout(() => {
            console.log('[ThemeHotReload] Performing initial theme check...');
            this.checkForChanges();
        }, 3000);

        // Also check after DOM is fully loaded
        if (document.readyState === 'complete') {
            setTimeout(() => {
                console.log('[ThemeHotReload] DOM ready, performing additional check...');
                this.checkForChanges();
            }, 5000);
        } else {
            window.addEventListener('load', () => {
                setTimeout(() => {
                    console.log('[ThemeHotReload] Window loaded, performing check...');
                    this.checkForChanges();
                }, 2000);
            });
        }
    }

    injectStyles() {
        if (document.getElementById('theme-hot-reload-styles')) return;

        const style = document.createElement('style');
        style.id = 'theme-hot-reload-styles';
        style.textContent = `
            .hot-reload-status {
                position: fixed;
                top: 20px;
                right: 20px;
                background: rgba(0, 0, 0, 0.8);
                color: #fff;
                padding: 8px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-family: 'Inter', sans-serif;
                z-index: 999999;
                backdrop-filter: blur(10px);
                border: 1px solid rgba(255, 255, 255, 0.1);
                opacity: 0;
                transform: translateY(-10px);
                transition: all 0.3s ease;
                pointer-events: none;
            }

            .hot-reload-status.visible {
                opacity: 1;
                transform: translateY(0);
            }

            .hot-reload-status.reloading {
                background: rgba(255, 165, 0, 0.9);
                animation: pulse 1s infinite;
            }

            .hot-reload-status.success {
                background: rgba(34, 197, 94, 0.9);
            }

            .hot-reload-status.error {
                background: rgba(239, 68, 68, 0.9);
            }

            @keyframes pulse {
                0%, 100% { opacity: 1; }
                50% { opacity: 0.7; }
            }
        `;
        document.head.appendChild(style);
    }

    startMonitoring() {
        // Initial check after a delay
        setTimeout(() => {
            this.checkForChanges();
        }, 1000);

        // Set up interval checking
        setInterval(() => {
            this.checkForChanges();
        }, this.checkInterval);
    }

    checkForChanges() {
        if (this.isReloading) return;

        // Method 1: Try XMLHttpRequest for local file
        this.checkWithXHR();

        // Method 2: Also try a simple content hash check as backup
        setTimeout(() => {
            this.checkWithContentHash();
        }, 500);

        // Method 3: Try Electron fs API if available
        if (window.require) {
            try {
                const fs = window.require('fs');
                const path = window.require('path');

                if (fs && fs.statSync) {
                    this.checkWithElectronFS(fs, path);
                }
            } catch (e) {
                // Electron fs not available or not in correct context
            }
        }
    }

    checkWithXHR() {
        const xhr = new XMLHttpRequest();
        xhr.open('GET', this.themePath + '?t=' + Date.now(), true);

        xhr.onreadystatechange = () => {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    const contentLength = xhr.getResponseHeader('Content-Length');
                    const lastModified = xhr.getResponseHeader('Last-Modified');

                    console.log('[ThemeHotReload] XHR check - Size:', contentLength, 'Modified:', lastModified);

                    // Check if file has changed
                    if ((this.lastSize !== null && this.lastSize !== contentLength) ||
                        (this.lastModified !== null && this.lastModified !== lastModified)) {
                        console.log('[ThemeHotReload] Theme file changed (XHR), reloading...');
                        console.log('[ThemeHotReload] Previous - Size:', this.lastSize, 'Modified:', this.lastModified);
                        console.log('[ThemeHotReload] Current - Size:', contentLength, 'Modified:', lastModified);
                        this.reloadTheme();
                    }

                    this.lastSize = contentLength;
                    this.lastModified = lastModified;
                } else {
                    console.log('[ThemeHotReload] XHR check failed with status:', xhr.status, 'URL:', xhr.responseURL);
                }
            }
        };

        xhr.onerror = (e) => {
            console.log('[ThemeHotReload] XHR request failed:', e);
        };

        xhr.send();
    }

    checkWithContentHash() {
        // Simple content-based check as backup
        const xhr = new XMLHttpRequest();
        xhr.open('GET', this.themePath + '?t=' + Date.now(), true);

        xhr.onreadystatechange = () => {
            if (xhr.readyState === 4 && xhr.status === 200) {
                const content = xhr.responseText;
                const hash = this.simpleHash(content);

                console.log('[ThemeHotReload] Content hash check - Hash:', hash, 'Length:', content.length);

                if (this.lastHash !== undefined && this.lastHash !== hash) {
                    console.log('[ThemeHotReload] Theme file changed (content hash), reloading...');
                    console.log('[ThemeHotReload] Previous hash:', this.lastHash, 'Current hash:', hash);
                    this.reloadTheme();
                }

                this.lastHash = hash;
            } else if (xhr.readyState === 4) {
                console.log('[ThemeHotReload] Content hash XHR failed with status:', xhr.status);
            }
        };

        xhr.onerror = (e) => {
            console.log('[ThemeHotReload] Content hash XHR failed:', e);
        };

        xhr.send();
    }

    checkWithElectronFS(fs, path) {
        try {
            const stats = fs.statSync(this.themePath);
            const mtime = stats.mtime.getTime();
            const size = stats.size;

            console.log('[ThemeHotReload] Electron FS check - Size:', size, 'MTime:', mtime);

            if (this.lastElectronMtime !== undefined && this.lastElectronMtime !== mtime) {
                console.log('[ThemeHotReload] Theme file changed (Electron FS), reloading...');
                this.reloadTheme();
            }

            this.lastElectronMtime = mtime;
            this.lastElectronSize = size;

        } catch (error) {
            console.log('[ThemeHotReload] Electron FS check failed:', error.message);
        }
    }

    simpleHash(str) {
        let hash = 0;
        for (let i = 0; i < str.length; i++) {
            const char = str.charCodeAt(i);
            hash = ((hash << 5) - hash) + char;
            hash = hash & hash; // Convert to 32-bit integer
        }
        return hash;
    }

    setupThemeChangeListener() {
        // Listen for custom theme change events
        window.addEventListener('themeChanged', () => {
            console.log('[ThemeHotReload] Theme change event received, reloading...');
            this.reloadTheme();
        });

        // Also listen for storage events (in case themes are stored)
        window.addEventListener('storage', (e) => {
            if (e.key && e.key.includes('theme')) {
                console.log('[ThemeHotReload] Storage theme change detected, reloading...');
                this.reloadTheme();
            }
        });
    }



    setupVisibilityListener() {
        // Check for theme changes when page becomes visible again
        document.addEventListener('visibilitychange', () => {
            if (!document.hidden) {
                console.log('[ThemeHotReload] Page became visible, checking for theme changes...');
                // Force a check when page becomes visible
                setTimeout(() => {
                    this.checkForChanges();
                }, 500);
            }
        });
    }

    async reloadTheme() {
        if (this.isReloading) return;

        this.isReloading = true;
        this.showStatus('Reloading theme...', 'reloading');
        console.log('[ThemeHotReload] Starting theme reload...');

        try {
            // Method 1: Try to reload the specific theme stylesheet
            const themeLink = this.findThemeStylesheet();
            if (themeLink) {
                console.log('[ThemeHotReload] Found theme stylesheet, reloading...');
                await this.reloadStylesheet(themeLink);
            } else {
                console.log('[ThemeHotReload] No theme stylesheet found, reloading all stylesheets...');
                await this.reloadAllStylesheets();
            }

            // Method 2: Force reload by updating CSS custom properties
            this.forceStyleUpdate();

            this.showStatus('Theme reloaded!', 'success');
            console.log('[ThemeHotReload] Theme reload completed successfully');

        } catch (error) {
            console.error('[ThemeHotReload] Reload failed:', error);
            this.showStatus('Reload failed', 'error');

            // Fallback: try a simple page refresh
            setTimeout(() => {
                if (confirm('Theme reload failed. Refresh page?')) {
                    window.location.reload();
                }
            }, 1000);
        } finally {
            this.isReloading = false;
            setTimeout(() => {
                this.hideStatus();
            }, 2000);
        }
    }

    forceStyleUpdate() {
        // Force update CSS custom properties by toggling a dummy property
        const root = document.documentElement;
        const currentValue = root.style.getPropertyValue('--hot-reload-trigger');
        const newValue = currentValue === '1' ? '2' : '1';
        root.style.setProperty('--hot-reload-trigger', newValue);

        // Also try to trigger a style recalculation
        document.body.offsetHeight; // Force reflow
    }

    findThemeStylesheet() {
        const links = document.querySelectorAll('link[rel="stylesheet"]');
        for (const link of links) {
            if (link.href && link.href.includes('omarchy-dynamic.theme.css')) {
                return link;
            }
        }
        return null;
    }

    async reloadStylesheet(linkElement) {
        return new Promise((resolve, reject) => {
            const newHref = linkElement.href.split('?')[0] + '?t=' + Date.now();

            const newLink = document.createElement('link');
            newLink.rel = 'stylesheet';
            newLink.href = newHref;

            newLink.onload = () => {
                // Remove old stylesheet
                if (linkElement.parentNode) {
                    linkElement.parentNode.removeChild(linkElement);
                }
                resolve();
            };

            newLink.onerror = reject;

            // Add new stylesheet
            document.head.appendChild(newLink);

            // Timeout fallback
            setTimeout(() => {
                resolve();
            }, 2000);
        });
    }

    async reloadAllStylesheets() {
        // Force reload all stylesheets by adding cache-busting parameter
        const links = document.querySelectorAll('link[rel="stylesheet"]');
        const reloadPromises = Array.from(links).map(link => {
            if (link.href) {
                const newHref = link.href.split('?')[0] + '?t=' + Date.now();
                link.href = newHref;
            }
        });

        // Wait a bit for stylesheets to reload
        await new Promise(resolve => setTimeout(resolve, 500));
    }

    showStatus(message, type = '') {
        let statusEl = document.getElementById('hot-reload-status');
        if (!statusEl) {
            statusEl = document.createElement('div');
            statusEl.id = 'hot-reload-status';
            statusEl.className = 'hot-reload-status';
            document.body.appendChild(statusEl);
        }

        statusEl.textContent = message;
        statusEl.className = 'hot-reload-status visible';

        if (type) {
            statusEl.classList.add(type);
        }

        // Auto-hide after 3 seconds unless it's an error
        if (type !== 'error') {
            setTimeout(() => {
                this.hideStatus();
            }, 3000);
        }
    }

    hideStatus() {
        const statusEl = document.getElementById('hot-reload-status');
        if (statusEl) {
            statusEl.classList.remove('visible');
        }
    }
}

// Manual reload function for debugging/testing
window.manualThemeReload = function() {
    if (window.themeHotReloadInstance) {
        window.themeHotReloadInstance.reloadTheme();
    } else {
        console.log('ThemeHotReload not initialized yet');
    }
};

// Function to trigger reload from external scripts
window.triggerThemeReload = function() {
    console.log('[ThemeHotReload] External reload trigger received');
    window.manualThemeReload();
};

// Add keyboard shortcut for manual reload (Ctrl+Shift+R)
document.addEventListener('keydown', function(e) {
    if (e.ctrlKey && e.shiftKey && e.key === 'R') {
        e.preventDefault();
        console.log('[ThemeHotReload] Manual reload triggered via Ctrl+Shift+R');
        window.manualThemeReload();
    }
});

// Initialize the hot reload system
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => {
        window.themeHotReloadInstance = new ThemeHotReload();
    });
} else {
    window.themeHotReloadInstance = new ThemeHotReload();
}

// Also initialize after a short delay to ensure DOM is ready
setTimeout(() => {
    if (!window.themeHotReloadInstance) {
        window.themeHotReloadInstance = new ThemeHotReload();
    }
}, 1000);