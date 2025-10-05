import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    port: 3000,
    host: true
  },
  optimizeDeps: {
    include: ['three', '@react-three/fiber'],
    exclude: ['standardized-audio-context']
  },
  build: {
    rollupOptions: {
      external: [
        './factories/get-backup-offline-audio-context'
      ]
    }
  }
})
