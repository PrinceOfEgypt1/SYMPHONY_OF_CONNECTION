#!/bin/bash

# ==========================================
# SYMPHONY OF CONNECTION - SETUP COMPLETO
# ==========================================

echo "🎵 Iniciando setup do Symphony of Connection..."

# Criar estrutura de diretórios
cd ~/workspace/SYMPHONY_OF_CONNECTION
mkdir -p frontend/src/{components,hooks,systems,utils,types}
mkdir -p backend/src/{services,utils,middleware}
mkdir -p shared/{types,utils}

# ==========================================
# FRONTEND SETUP
# ==========================================

echo "📦 Configurando frontend..."

cd frontend

# Criar package.json
cat > package.json << 'EOF'
{
  "name": "symphony-frontend",
  "private": true,
  "version": "0.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "tsc && vite build",
    "lint": "eslint . --ext ts,tsx --report-unused-disable-directives --max-warnings 0",
    "preview": "vite preview"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "three": "^0.158.0",
    "@react-three/fiber": "^8.15.0",
    "@react-three/drei": "^9.85.0",
    "tone": "^14.7.77",
    "socket.io-client": "^4.7.0",
    "framer-motion": "^10.16.0",
    "zustand": "^4.4.0"
  },
  "devDependencies": {
    "@types/react": "^18.2.0",
    "@types/react-dom": "^18.2.0",
    "@types/three": "^0.158.0",
    "@vitejs/plugin-react": "^4.1.0",
    "typescript": "^5.0.0",
    "vite": "^4.4.0"
  }
}
EOF

# Criar vite.config.ts
cat > vite.config.ts << 'EOF'
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    port: 3000,
    host: true
  },
  optimizeDeps: {
    include: ['three', '@react-three/fiber']
  }
})
EOF

# Criar tsconfig.json
cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "useDefineForClassFields": true,
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "skipLibCheck": true,
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx",
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true
  },
  "include": ["src"],
  "references": [{ "path": "./tsconfig.node.json" }]
}
EOF

# Criar tsconfig.node.json
cat > tsconfig.node.json << 'EOF'
{
  "compilerOptions": {
    "composite": true,
    "skipLibCheck": true,
    "module": "ESNext",
    "moduleResolution": "bundler",
    "allowSyntheticDefaultImports": true
  },
  "include": ["vite.config.ts"]
}
EOF

# Criar index.html
cat > index.html << 'EOF'
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <link rel="icon" type="image/svg+xml" href="/vite.svg" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Symphony of Connection</title>
    <style>
      body {
        margin: 0;
        padding: 0;
        overflow: hidden;
        background: #000;
      }
    </style>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>
EOF

# ==========================================
# ESTRUTURA DE ARQUIVOS FRONTEND
# ==========================================

# Criar main.tsx
cat > src/main.tsx << 'EOF'
import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App.tsx'

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
)
EOF

# Criar App.tsx
cat > src/App.tsx << 'EOF'
import React from 'react'
import { Canvas } from '@react-three/fiber'
import { Experience } from './components/Experience'
import { Interface } from './components/Interface'
import { AudioEngine } from './systems/AudioEngine'
import { useSymphonyStore } from './stores/symphonyStore'

function App() {
  const { audioEnabled } = useSymphonyStore()

  return (
    <div style={{ width: '100vw', height: '100vh', background: 'black' }}>
      <Canvas
        camera={{ position: [0, 0, 8], fov: 60 }}
        gl={{ 
          antialias: true,
          alpha: true,
          powerPreference: "high-performance"
        }}
        dpr={[1, 2]}
      >
        <Experience />
      </Canvas>
      
      <Interface />
      {audioEnabled && <AudioEngine />}
    </div>
  )
}

export default App
EOF

# Criar types
cat > src/types/symphony.ts << 'EOF'
export interface EmotionalVector {
  joy: number
  excitement: number
  calm: number
  curiosity: number
  intensity: number
  fluidity: number
  connection: number
}

export interface UserState {
  id: string
  emotionalVector: EmotionalVector
  position: [number, number, number]
  color: string
  connected: boolean
}

export interface SymphonyState {
  users: UserState[]
  emotionalField: EmotionalVector
  connectionStrength: number
  audioIntensity: number
}
EOF

# Criar store Zustand
cat > src/stores/symphonyStore.ts << 'EOF'
import { create } from 'zustand'
import { EmotionalVector, SymphonyState, UserState } from '../types/symphony'

interface SymphonyStore {
  // Estado emocional do usuário local
  emotionalVector: EmotionalVector
  setEmotionalVector: (vector: EmotionalVector) => void
  updateEmotion: (emotion: keyof EmotionalVector, value: number) => void
  
  // Estado da sinfonia
  symphonyState: SymphonyState
  setSymphonyState: (state: SymphonyState) => void
  
  // Configurações
  audioEnabled: boolean
  setAudioEnabled: (enabled: boolean) => void
  
  // Controles
  mousePosition: [number, number]
  setMousePosition: (position: [number, number]) => void
  mouseIntensity: number
  setMouseIntensity: (intensity: number) => void
}

export const useSymphonyStore = create<SymphonyStore>((set, get) => ({
  // Estado emocional inicial
  emotionalVector: {
    joy: 0.5,
    excitement: 0.3,
    calm: 0.7,
    curiosity: 0.6,
    intensity: 0.4,
    fluidity: 0.5,
    connection: 0.2
  },
  
  setEmotionalVector: (vector) => set({ emotionalVector: vector }),
  
  updateEmotion: (emotion, value) => {
    const current = get().emotionalVector
    set({ 
      emotionalVector: {
        ...current,
        [emotion]: Math.max(0, Math.min(1, value))
      }
    })
  },
  
  // Estado da sinfonia
  symphonyState: {
    users: [],
    emotionalField: {
      joy: 0.5,
      excitement: 0.3,
      calm: 0.7,
      curiosity: 0.6,
      intensity: 0.4,
      fluidity: 0.5,
      connection: 0.2
    },
    connectionStrength: 0.3,
    audioIntensity: 0.5
  },
  
  setSymphonyState: (state) => set({ symphonyState: state }),
  
  // Configurações
  audioEnabled: true,
  setAudioEnabled: (enabled) => set({ audioEnabled: enabled }),
  
  // Controles de mouse
  mousePosition: [0, 0],
  setMousePosition: (position) => set({ mousePosition: position }),
  
  mouseIntensity: 0,
  setMouseIntensity: (intensity) => set({ mouseIntensity: intensity })
}))
EOF

# Criar componente Experience
cat > src/components/Experience.tsx << 'EOF'
import React, { useRef, useMemo, useEffect } from 'react'
import { useFrame, useThree } from '@react-three/fiber'
import * as THREE from 'three'
import { useSymphonyStore } from '../stores/symphonyStore'

export const Experience: React.FC = () => {
  const particlesRef = useRef<THREE.Points>(null)
  const { mousePosition, mouseIntensity, emotionalVector } = useSymphonyStore()
  const { size, viewport } = useThree()

  // Sistema de partículas
  const particleSystem = useMemo(() => {
    const particleCount = 2000
    const positions = new Float32Array(particleCount * 3)
    const colors = new Float32Array(particleCount * 3)
    const sizes = new Float32Array(particleCount)

    for (let i = 0; i < particleCount; i++) {
      // Posições em uma esfera
      const i3 = i * 3
      const radius = 4 + Math.random() * 2
      const theta = Math.random() * Math.PI * 2
      const phi = Math.acos(2 * Math.random() - 1)
      
      positions[i3] = radius * Math.sin(phi) * Math.cos(theta)
      positions[i3 + 1] = radius * Math.sin(phi) * Math.sin(theta)
      positions[i3 + 2] = radius * Math.cos(phi)
      
      // Cores baseadas na posição
      colors[i3] = 0.5 + 0.5 * Math.sin(theta)
      colors[i3 + 1] = 0.5 + 0.5 * Math.cos(phi)
      colors[i3 + 2] = 0.5 + 0.5 * Math.sin(theta + phi)
      
      // Tamanhos variados
      sizes[i] = 0.02 + Math.random() * 0.03
    }

    const geometry = new THREE.BufferGeometry()
    geometry.setAttribute('position', new THREE.BufferAttribute(positions, 3))
    geometry.setAttribute('color', new THREE.BufferAttribute(colors, 3))
    geometry.setAttribute('size', new THREE.BufferAttribute(sizes, 1))
    
    return geometry
  }, [])

  // Animação das partículas
  useFrame((state, delta) => {
    if (particlesRef.current) {
      const time = state.clock.elapsedTime
      
      // Rotação suave baseada no tempo
      particlesRef.current.rotation.x = time * 0.05
      particlesRef.current.rotation.y = time * 0.03
      
      // Influência do mouse na rotação
      particlesRef.current.rotation.x += (mousePosition[1] * 0.5 - particlesRef.current.rotation.x) * 0.1
      particlesRef.current.rotation.y += (mousePosition[0] * 0.5 - particlesRef.current.rotation.y) * 0.1
      
      // Pulsação baseada na intensidade emocional
      const scale = 1 + emotionalVector.intensity * 0.3 + Math.sin(time * 2) * 0.1
      particlesRef.current.scale.setScalar(scale)
    }
  })

  // Efeito do mouse
  useEffect(() => {
    const handleMouseMove = (event: MouseEvent) => {
      const x = (event.clientX / size.width) * 2 - 1
      const y = -(event.clientY / size.height) * 2 + 1
      
      useSymphonyStore.getState().setMousePosition([x, y])
      
      // Calcular intensidade baseada na velocidade do mouse
      const intensity = Math.sqrt(x * x + y * y) * 2
      useSymphonyStore.getState().setMouseIntensity(intensity)
      
      // Atualizar emoções baseadas no movimento do mouse
      useSymphonyStore.getState().updateEmotion('intensity', intensity)
      useSymphonyStore.getState().updateEmotion('excitement', intensity * 0.8)
    }

    window.addEventListener('mousemove', handleMouseMove)
    return () => window.removeEventListener('mousemove', handleMouseMove)
  }, [size])

  return (
    <>
      <points ref={particlesRef}>
        <primitive object={particleSystem} />
        <pointsMaterial
          size={0.05}
          sizeAttenuation={true}
          vertexColors={true}
          transparent
          opacity={0.8}
          blending={THREE.AdditiveBlending}
        />
      </points>
      
      <ambientLight intensity={0.3} />
      <pointLight position={[10, 10, 10]} intensity={1.5} color="#ff6b6b" />
      <pointLight position={[-10, -10, 5]} intensity={1} color="#4ecdc4" />
    </>
  )
}
EOF

# Criar componente Interface
cat > src/components/Interface.tsx << 'EOF'
import React from 'react'
import { motion } from 'framer-motion'
import { useSymphonyStore } from '../stores/symphonyStore'

export const Interface: React.FC = () => {
  const { emotionalVector, audioEnabled, setAudioEnabled } = useSymphonyStore()

  return (
    <div style={{
      position: 'fixed',
      top: 0,
      left: 0,
      width: '100%',
      padding: '20px',
      color: 'white',
      fontFamily: 'Arial, sans-serif',
      pointerEvents: 'none',
      zIndex: 1000
    }}>
      {/* Header */}
      <motion.div
        initial={{ opacity: 0, y: -20 }}
        animate={{ opacity: 1, y: 0 }}
        style={{
          display: 'flex',
          justifyContent: 'space-between',
          alignItems: 'flex-start'
        }}
      >
        <div>
          <h1 style={{ margin: 0, fontSize: '24px', fontWeight: 'bold' }}>
            🎵 Symphony of Connection
          </h1>
          <p style={{ margin: '5px 0 0 0', opacity: 0.8 }}>
            Mova o mouse para criar música e emoções visuais
          </p>
        </div>
        
        <motion.button
          onClick={() => setAudioEnabled(!audioEnabled)}
          style={{
            pointerEvents: 'auto',
            background: 'rgba(255, 255, 255, 0.1)',
            border: '1px solid rgba(255, 255, 255, 0.3)',
            color: 'white',
            padding: '8px 16px',
            borderRadius: '20px',
            cursor: 'pointer',
            backdropFilter: 'blur(10px)'
          }}
          whileHover={{ scale: 1.05 }}
          whileTap={{ scale: 0.95 }}
        >
          {audioEnabled ? '🔊 Áudio Ativo' : '🔇 Áudio Mudo'}
        </motion.button>
      </motion.div>

      {/* Emotional Status */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.5 }}
        style={{
          position: 'fixed',
          bottom: '20px',
          left: '20px',
          background: 'rgba(0, 0, 0, 0.5)',
          padding: '15px',
          borderRadius: '10px',
          backdropFilter: 'blur(10px)',
          border: '1px solid rgba(255, 255, 255, 0.1)'
        }}
      >
        <h3 style={{ margin: '0 0 10px 0', fontSize: '14px', opacity: 0.8 }}>
          Estado Emocional
        </h3>
        
        {Object.entries(emotionalVector).map(([emotion, value]) => (
          <div key={emotion} style={{ marginBottom: '5px' }}>
            <div style={{
              display: 'flex',
              justifyContent: 'space-between',
              fontSize: '12px',
              marginBottom: '2px'
            }}>
              <span style={{ textTransform: 'capitalize' }}>
                {emotion}:
              </span>
              <span>
                {Math.round(value * 100)}%
              </span>
            </div>
            <div style={{
              width: '150px',
              height: '4px',
              background: 'rgba(255, 255, 255, 0.2)',
              borderRadius: '2px',
              overflow: 'hidden'
            }}>
              <motion.div
                initial={{ width: 0 }}
                animate={{ width: `${value * 100}%` }}
                transition={{ duration: 0.5 }}
                style={{
                  height: '100%',
                  background: `linear-gradient(90deg, #ff6b6b, #4ecdc4)`,
                  borderRadius: '2px'
                }}
              />
            </div>
          </div>
        ))}
      </motion.div>

      {/* Instructions */}
      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ delay: 1 }}
        style={{
          position: 'fixed',
          bottom: '20px',
          right: '20px',
          textAlign: 'right',
          fontSize: '12px',
          opacity: 0.6
        }}
      >
        <div>🎮 Movimento do mouse = Intensidade emocional</div>
        <div>🎵 Velocidade = Ritmo musical</div>
        <div>🌈 Padrões = Harmonia visual</div>
      </motion.div>
    </div>
  )
}
EOF

# Criar sistema de áudio
cat > src/systems/AudioEngine.tsx << 'EOF'
import React, { useEffect, useRef } from 'react'
import * as Tone from 'tone'
import { useSymphonyStore } from '../stores/symphonyStore'

export const AudioEngine: React.FC = () => {
  const { emotionalVector, mouseIntensity } = useSymphonyStore()
  const synthRef = useRef<Tone.PolySynth | null>(null)
  const reverbRef = useRef<Tone.Reverb | null>(null)
  const filterRef = useRef<Tone.Filter | null>(null)

  useEffect(() => {
    // Inicializar sintetizador
    synthRef.current = new Tone.PolySynth(Tone.Synth, {
      oscillator: {
        type: 'sine'
      },
      envelope: {
        attack: 0.02,
        decay: 0.1,
        sustain: 0.3,
        release: 1
      }
    }).toDestination()

    // Efeitos
    reverbRef.current = new Tone.Reverb({
      decay: 2,
      wet: 0.3
    }).toDestination()

    filterRef.current = new Tone.Filter({
      frequency: 800,
      type: 'lowpass',
      Q: 1
    })

    // Conectar a cadeia de áudio
    synthRef.current.connect(filterRef.current)
    filterRef.current.connect(reverbRef.current)

    // Iniciar áudio no primeiro clique do usuário
    const handleFirstClick = async () => {
      await Tone.start()
      console.log('Áudio iniciado')
      document.removeEventListener('click', handleFirstClick)
    }

    document.addEventListener('click', handleFirstClick)

    return () => {
      synthRef.current?.dispose()
      reverbRef.current?.dispose()
      filterRef.current?.dispose()
      document.removeEventListener('click', handleFirstClick)
    }
  }, [])

  // Efeito para gerar notas baseadas nas emoções
  useEffect(() => {
    if (!synthRef.current) return

    const { joy, excitement, calm, intensity } = emotionalVector
    
    // Frequência baseada nas emoções
    const baseFreq = 220 + (joy * 200) + (excitement * 100)
    
    // Ritmo baseado na intensidade
    const rhythm = Math.max(0.1, intensity * 2)
    
    // Tocar notas baseadas no movimento do mouse
    if (mouseIntensity > 0.3 && Math.random() < rhythm) {
      const notes = ['C4', 'E4', 'G4', 'B4', 'D5']
      const note = notes[Math.floor(Math.random() * notes.length)]
      
      synthRef.current.triggerAttackRelease(note, '8n')
    }

    // Atualizar filtro baseado na calma
    if (filterRef.current) {
      filterRef.current.frequency.value = 200 + (calm * 1000)
    }

  }, [emotionalVector, mouseIntensity])

  return null
}
EOF

# ==========================================
# BACKEND SETUP
# ==========================================

echo "🔧 Configurando backend..."

cd ../backend

# Criar package.json do backend
cat > package.json << 'EOF'
{
  "name": "symphony-backend",
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "dev": "tsx watch src/server.ts",
    "build": "tsc",
    "start": "node dist/server.js"
  },
  "dependencies": {
    "express": "^4.18.0",
    "socket.io": "^4.7.0",
    "cors": "^2.8.5"
  },
  "devDependencies": {
    "@types/express": "^4.17.0",
    "@types/cors": "^2.8.0",
    "tsx": "^4.0.0",
    "typescript": "^5.0.0"
  }
}
EOF

# Criar tsconfig.json do backend
cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "ESNext",
    "moduleResolution": "node",
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "strict": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "outDir": "./dist",
    "rootDir": "./src"
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
EOF

# Criar servidor básico
mkdir -p src
cat > src/server.ts << 'EOF'
import express from 'express'
import { createServer } from 'http'
import { Server } from 'socket.io'
import cors from 'cors'

const app = express()
const server = createServer(app)
const io = new Server(server, {
  cors: {
    origin: "http://localhost:3000",
    methods: ["GET", "POST"]
  }
})

app.use(cors())
app.use(express.json())

// Estado da sinfonia
const symphonyState = {
  users: new Map(),
  emotionalField: {
    joy: 0.5,
    excitement: 0.3,
    calm: 0.7,
    curiosity: 0.6,
    intensity: 0.4,
    fluidity: 0.5,
    connection: 0.2
  }
}

io.on('connection', (socket) => {
  console.log('Usuário conectado:', socket.id)

  // Adicionar usuário ao estado
  symphonyState.users.set(socket.id, {
    id: socket.id,
    emotionalVector: symphonyState.emotionalField,
    position: [0, 0, 0],
    color: `hsl(${Math.random() * 360}, 70%, 60%)`,
    connected: true
  })

  // Enviar estado inicial para o usuário
  socket.emit('symphony-state', {
    users: Array.from(symphonyState.users.values()),
    emotionalField: symphonyState.emotionalField
  })

  // Notificar outros usuários
  socket.broadcast.emit('user-joined', {
    user: symphonyState.users.get(socket.id)
  })

  // Lidar com atualizações emocionais
  socket.on('emotional-update', (data) => {
    const user = symphonyState.users.get(socket.id)
    if (user) {
      user.emotionalVector = data.emotionalVector
      
      // Atualizar campo emocional geral (média simples)
      const usersArray = Array.from(symphonyState.users.values())
      symphonyState.emotionalField = {
        joy: usersArray.reduce((sum, u) => sum + u.emotionalVector.joy, 0) / usersArray.length,
        excitement: usersArray.reduce((sum, u) => sum + u.emotionalVector.excitement, 0) / usersArray.length,
        calm: usersArray.reduce((sum, u) => sum + u.emotionalVector.calm, 0) / usersArray.length,
        curiosity: usersArray.reduce((sum, u) => sum + u.emotionalVector.curiosity, 0) / usersArray.length,
        intensity: usersArray.reduce((sum, u) => sum + u.emotionalVector.intensity, 0) / usersArray.length,
        fluidity: usersArray.reduce((sum, u) => sum + u.emotionalVector.fluidity, 0) / usersArray.length,
        connection: usersArray.reduce((sum, u) => sum + u.emotionalVector.connection, 0) / usersArray.length
      }

      // Broadcast para todos os usuários
      io.emit('symphony-update', {
        users: Array.from(symphonyState.users.values()),
        emotionalField: symphonyState.emotionalField
      })
    }
  })

  // Lidar com desconexão
  socket.on('disconnect', () => {
    console.log('Usuário desconectado:', socket.id)
    symphonyState.users.delete(socket.id)
    
    // Notificar outros usuários
    socket.broadcast.emit('user-left', { userId: socket.id })
  })
})

const PORT = process.env.PORT || 5000
server.listen(PORT, () => {
  console.log(`🎵 Symphony Server rodando na porta ${PORT}`)
})
EOF

# ==========================================
# INSTALAÇÃO E INICIALIZAÇÃO
# ==========================================

echo "📦 Instalando dependências..."

# Instalar dependências do frontend
cd ../frontend
npm install

echo "✅ Setup completo!"
echo ""
echo "🚀 Para iniciar o projeto:"
echo "Frontend: cd frontend && npm run dev"
echo "Backend:  cd backend && npm run dev"
echo ""
echo "🌐 Frontend: http://localhost:3000"
echo "🔧 Backend:  http://localhost:5000"
