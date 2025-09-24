import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import tailwindcss from '@tailwindcss/vite'

// https://vite.dev/config/
export default defineConfig({
  plugins: [react(),
    tailwindcss(),
  ],
  server: {
    host: '54.221.31.187',
    port: 5173,
    strictPort: true,
    hmr: {
      protocol: 'ws',
      host: '54.221.31.187',
      port: 5173,
      clientPort: 5173,
      timeout: 30000,
      overlay: false
    },
    watch: {
      usePolling: true,
      interval: 1000,
    },
    cors: true,
    proxy: {
      '/api': {
        target: 'http://54.221.31.187:8081',
        changeOrigin: true,
        secure: false
      }
    }
  }
})
