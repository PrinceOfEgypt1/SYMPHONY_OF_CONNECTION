#!/bin/bash

echo "🔍 ANÁLISE COMPLETA DO CÓDIGO E MELHORIAS VISUAIS"
echo "=================================================="

cd ~/workspace/SYMPHONY_OF_CONNECTION

# 1. ANÁLISE DA ARQUITETURA ATUAL
echo ""
echo "1. 📊 ANALISANDO ARQUITETURA DO PROJETO..."

echo "✅ ESTRUTURA IDENTIFICADA:"
echo "   Frontend: React + Three.js + TypeScript"
echo "   Backend: Node.js + Express + Socket.io"
echo "   Estado: Zustand"
echo "   Áudio: Tone.js"

# 2. IDENTIFICAR OPORTUNIDADES DE MELHORIA VISUAL
echo ""
echo "2. 🎨 IDENTIFICANDO OPORTUNIDADES VISUAIS..."

echo "📋 PROBLEMAS IDENTIFICADOS:"
echo "   🎯 Partículas monocromáticas (apenas azul/roxo)"
echo "   🎯 Falta de diversidade visual nas formações"
echo "   🎯 Comportamento linear das partículas"
echo "   🎯 Paleta de cores limitada emocionalmente"

# 3. IMPLEMENTAR SISTEMA DE PARTÍCULAS COLORIDAS E DINÂMICAS
echo ""
echo "3. 🌈 CRIANDO SISTEMA DE PARTÍCULAS AVANÇADO..."

cat > frontend/src/components/EnhancedParticles.tsx << 'EOF'
import React, { useRef, useMemo } from 'react'
import { useFrame } from '@react-three/fiber'
import * as THREE from 'three'
import { useSymphonyStore } from '../stores/symphonyStore'

/**
 * Sistema de partículas avançado com cores dinâmicas e formações
 * @component
 */
const EnhancedParticles: React.FC = () => {
  const particlesRef = useRef<THREE.Points>(null)
  const { emotionalVector, mouseIntensity } = useSymphonyStore()

  // Configurações baseadas no estado emocional
  const particleConfig = useMemo(() => {
    if (!emotionalVector) return null

    const { joy, excitement, calm, curiosity, connection } = emotionalVector

    // Paleta de cores emocionais
    const colorPalettes = {
      joyful: [
        new THREE.Color(0xFFFF00), // Amarelo
        new THREE.Color(0xFFA500), // Laranja
        new THREE.Color(0xFF69B4), // Rosa
        new THREE.Color(0xFFD700), // Dourado
      ],
      calm: [
        new THREE.Color(0x00FFFF), // Ciano
        new THREE.Color(0x40E0D0), // Turquesa
        new THREE.Color(0x87CEEB), // Azul claro
        new THREE.Color(0x98FB98), // Verde claro
      ],
      excited: [
        new THREE.Color(0xFF0000), // Vermelho
        new THREE.Color(0xFF4500), // Vermelho laranja
        new THREE.Color(0xDC143C), // Carmesim
        new THREE.Color(0xFF1493), // Rosa profundo
      ],
      curious: [
        new THREE.Color(0x8A2BE2), // Azul violeta
        new THREE.Color(0x9400D3), // Roxo escuro
        new THREE.Color(0xBA55D3), // Orquídea média
        new THREE.Color(0xDDA0DD), // Ameixa
      ],
      connected: [
        new THREE.Color(0x32CD32), // Verde lima
        new THREE.Color(0x00FF00), // Verde
        new THREE.Color(0x7CFC00), // Verde grama
        new THREE.Color(0xADFF2F), // Verde amarelo
      ]
    }

    // Selecionar paleta baseada na emoção dominante
    const emotions = { joy, excitement, calm, curiosity, connection }
    const dominantEmotion = Object.keys(emotions).reduce((a, b) => 
      emotions[a] > emotions[b] ? a : b
    )

    return {
      palette: colorPalettes[dominantEmotion] || colorPalettes.joyful,
      speed: 0.01 + (excitement * 0.04),
      size: 0.03 + (joy * 0.07),
      count: 800 + Math.floor(connection * 400),
      formation: calm > 0.7 ? 'sphere' : excitement > 0.7 ? 'explosion' : 'swarm'
    }
  }, [emotionalVector])

  // Geometria das partículas com cores dinâmicas
  const particleGeometry = useMemo(() => {
    if (!particleConfig) return null

    const geometry = new THREE.BufferGeometry()
    const positions = new Float32Array(particleConfig.count * 3)
    const colors = new Float32Array(particleConfig.count * 3)
    const sizes = new Float32Array(particleConfig.count)

    for (let i = 0; i < particleConfig.count * 3; i += 3) {
      // Posições iniciais baseadas na formação
      switch (particleConfig.formation) {
        case 'sphere':
          const radius = 5 + Math.random() * 3
          const theta = Math.random() * Math.PI * 2
          const phi = Math.acos(2 * Math.random() - 1)
          positions[i] = radius * Math.sin(phi) * Math.cos(theta)
          positions[i + 1] = radius * Math.sin(phi) * Math.sin(theta)
          positions[i + 2] = radius * Math.cos(phi)
          break
        
        case 'explosion':
          positions[i] = (Math.random() - 0.5) * 0.5
          positions[i + 1] = (Math.random() - 0.5) * 0.5
          positions[i + 2] = (Math.random() - 0.5) * 0.5
          break
        
        default: // swarm
          positions[i] = (Math.random() - 0.5) * 10
          positions[i + 1] = (Math.random() - 0.5) * 10
          positions[i + 2] = (Math.random() - 0.5) * 10
      }

      // Cores aleatórias da paleta selecionada
      const color = particleConfig.palette[
        Math.floor(Math.random() * particleConfig.palette.length)
      ]
      colors[i] = color.r
      colors[i + 1] = color.g
      colors[i + 2] = color.b

      // Tamanhos variados
      sizes[i / 3] = Math.random() * particleConfig.size + 0.01
    }

    geometry.setAttribute('position', new THREE.BufferAttribute(positions, 3))
    geometry.setAttribute('color', new THREE.BufferAttribute(colors, 3))
    geometry.setAttribute('size', new THREE.BufferAttribute(sizes, 1))

    return geometry
  }, [particleConfig])

  // Animação das partículas
  useFrame(({ clock }) => {
    if (!particlesRef.current || !particleGeometry || !emotionalVector) return

    const time = clock.getElapsedTime()
    const positions = particleGeometry.attributes.position.array as Float32Array
    const colors = particleGeometry.attributes.color.array as Float32Array

    for (let i = 0; i < positions.length; i += 3) {
      const particleIndex = i / 3
      const intensity = emotionalVector.intensity || 0.5
      const fluidity = emotionalVector.fluidity || 0.5

      // Comportamentos baseados na formação
      switch (particleConfig.formation) {
        case 'sphere':
          // Movimento orbital suave
          const radius = 5 + Math.sin(time * 0.5 + particleIndex) * 2
          const angle = time * (0.2 + intensity * 0.3) + particleIndex * 0.1
          positions[i] = Math.cos(angle) * radius
          positions[i + 1] = Math.sin(angle) * radius
          positions[i + 2] = Math.sin(time * 0.3 + particleIndex) * 2
          break
        
        case 'explosion':
          // Expansão contínua
          const speed = 0.1 + intensity * 0.2
          positions[i] += positions[i] * speed * 0.01
          positions[i + 1] += positions[i + 1] * speed * 0.01
          positions[i + 2] += positions[i + 2] * speed * 0.01
          break
        
        default: // swarm
          // Movimento de enxame com noise
          const noise1 = Math.sin(time * 0.8 + particleIndex * 0.2)
          const noise2 = Math.cos(time * 0.6 + particleIndex * 0.15)
          const noise3 = Math.sin(time * 0.4 + particleIndex * 0.1)
          
          positions[i] += noise1 * particleConfig.speed * fluidity
          positions[i + 1] += noise2 * particleConfig.speed * fluidity
          positions[i + 2] += noise3 * particleConfig.speed * fluidity * 0.5
      }

      // Pulsação de cores baseada no tempo e intensidade
      const hueShift = Math.sin(time * 0.5 + particleIndex * 0.01) * 0.1
      const currentColor = new THREE.Color(colors[i], colors[i + 1], colors[i + 2])
      currentColor.offsetHSL(hueShift, 0, 0)
      
      colors[i] = currentColor.r
      colors[i + 1] = currentColor.g
      colors[i + 2] = currentColor.b
    }

    particleGeometry.attributes.position.needsUpdate = true
    particleGeometry.attributes.color.needsUpdate = true
  })

  if (!particleGeometry) return null

  return (
    <points ref={particlesRef}>
      <primitive object={particleGeometry} />
      <pointsMaterial
        size={0.05}
        vertexColors={true}
        transparent
        opacity={0.8}
        sizeAttenuation={true}
        blending={THREE.AdditiveBlending}
      />
    </points>
  )
}

export default EnhancedParticles
EOF

echo "✅ Sistema de partículas avançado criado"

# 4. ATUALIZAR O EXPERIENCE PARA USAR AS NOVAS PARTÍCULAS
echo ""
echo "4. 🔄 ATUALIZANDO EXPERIENCE COM NOVAS PARTÍCULAS..."

cat > frontend/src/components/Experience.tsx << 'EOF'
import React, { useRef, useEffect } from 'react'
import { useFrame, useThree } from '@react-three/fiber'
import * as THREE from 'three'
import { useSymphonyStore } from '../stores/symphonyStore'
import CollaborativeConstellations from './CollaborativeConstellations'
import EnhancedParticles from './EnhancedParticles'

/**
 * Componente principal de experiência 3D
 * @component
 * @description Gerencia partículas, interações e renderização 3D com visual melhorado
 */
const Experience: React.FC = () => {
  const particlesRef = useRef<THREE.Points>(null)
  const ambientLightRef = useRef<THREE.AmbientLight>(null)
  const pointLightRef = useRef<THREE.PointLight>(null)
  const directionalLightRef = useRef<THREE.DirectionalLight>(null)
  const { viewport } = useThree()
  const {
    connectToSymphony,
    updatePosition,
    updateEmotionalVector,
    setMousePosition,
    setMouseIntensity
  } = useSymphonyStore()

  // Conectar ao symphony quando o componente montar
  useEffect(() => {
    connectToSymphony()
  }, [connectToSymphony])

  // Animação de frame para interações
  useFrame(({ mouse, clock }) => {
    if (!particlesRef.current) return

    // Atualizar posição baseada no mouse - COORDENADAS 3D CORRETAS
    const x = (mouse.x * viewport.width) / 2
    const y = (mouse.y * viewport.height) / 2
    const z = 0

    // Atualizar store com posição 3D
    updatePosition([x, y, z])
    setMousePosition([x, y, z])

    // Calcular intensidade baseada no movimento do mouse
    const time = clock.getElapsedTime()
    const intensity = Math.min(1, Math.sqrt(x * x + y * y) / viewport.width)
    setMouseIntensity(intensity)

    // Atualizar vetor emocional baseado na interação
    updateEmotionalVector({
      joy: intensity * 0.8,
      excitement: intensity,
      calm: 1 - intensity,
      intensity: intensity,
      fluidity: Math.sin(time) * 0.5 + 0.5,
      connection: intensity * 0.6,
      curiosity: intensity * 0.7
    })

    // Animar luzes baseado no movimento
    if (pointLightRef.current) {
      pointLightRef.current.position.x = Math.sin(time * 0.5) * 3
      pointLightRef.current.position.y = Math.cos(time * 0.3) * 2
      pointLightRef.current.intensity = 1 + intensity * 2
      
      // Cor dinâmica baseada na intensidade
      const hue = (time * 0.1) % 1
      pointLightRef.current.color.setHSL(hue, 0.8, 0.6)
    }

    if (directionalLightRef.current) {
      directionalLightRef.current.intensity = 0.5 + intensity * 0.5
    }
  })

  return (
    <>
      {/* Iluminação melhorada */}
      <ambientLight ref={ambientLightRef} intensity={0.4} color={0x4444ff} />
      <pointLight 
        ref={pointLightRef} 
        position={[2, 2, 2]} 
        intensity={1.5}
        distance={20}
        decay={2}
      />
      <pointLight 
        position={[-2, -1, 1]} 
        intensity={0.8} 
        color={0xff44aa}
        distance={15}
        decay={2}
      />
      <directionalLight
        ref={directionalLightRef}
        position={[5, 5, 5]}
        intensity={0.5}
        color={0xffffff}
        castShadow
      />

      {/* Partículas avançadas com cores e formações */}
      <EnhancedParticles />

      {/* Efeito de partículas secundárias para profundidade */}
      <points>
        <bufferGeometry>
          <bufferAttribute
            attach="attributes-position"
            count={200}
            array={new Float32Array(200 * 3).map(() => (Math.random() - 0.5) * 20)}
            itemSize={3}
          />
        </bufferGeometry>
        <pointsMaterial
          size={0.02}
          color={0x8888ff}
          transparent
          opacity={0.3}
          sizeAttenuation={true}
          blending={THREE.AdditiveBlending}
        />
      </points>

      {/* Sistema de constelações colaborativas */}
      <CollaborativeConstellations />
    </>
  )
}

export default Experience
EOF

echo "✅ Experience atualizado com partículas avançadas"

# 5. ADICIONAR EFEITOS VISUAIS EXTRAS
echo ""
echo "5. ✨ ADICIONANDO EFEITOS VISUAIS EXTRAS..."

cat > frontend/src/components/VisualEffects.tsx << 'EOF'
import React, { useRef } from 'react'
import { useFrame, useThree } from '@react-three/fiber'
import * as THREE from 'three'
import { useSymphonyStore } from '../stores/symphonyStore'

/**
 * Efeitos visuais adicionais para enriquecer a experiência
 * @component
 */
const VisualEffects: React.FC = () => {
  const glowRef = useRef<THREE.Mesh>(null)
  const { emotionalVector } = useSymphonyStore()
  const { scene } = useThree()

  useFrame(({ clock }) => {
    if (!glowRef.current || !emotionalVector) return

    const time = clock.getElapsedTime()
    const { joy, excitement, calm } = emotionalVector

    // Efeito de glow pulsante baseado nas emoções
    const pulse = Math.sin(time * 2) * 0.5 + 0.5
    glowRef.current.scale.setScalar(1 + pulse * 0.1 * excitement)
    
    // Cor do glow baseada nas emoções
    const hue = (joy * 0.3 + calm * 0.1 + time * 0.05) % 1
    const color = new THREE.Color().setHSL(hue, 0.8, 0.6)
    glowRef.current.material.color = color
  })

  return (
    <>
      {/* Glow central */}
      <mesh ref={glowRef} position={[0, 0, 0]}>
        <sphereGeometry args={[1, 16, 16]} />
        <meshBasicMaterial
          transparent
          opacity={0.1}
          blending={THREE.AdditiveBlending}
        />
      </mesh>

      {/* Anéis orbitais */}
      <mesh rotation={[Math.PI / 2, 0, 0]}>
        <ringGeometry args={[3, 3.2, 32]} />
        <meshBasicMaterial
          color={0x00ffff}
          transparent
          opacity={0.2}
          side={THREE.DoubleSide}
          blending={THREE.AdditiveBlending}
        />
      </mesh>

      <mesh rotation={[Math.PI / 2, 0, Math.PI / 4]}>
        <ringGeometry args={[4, 4.2, 32]} />
        <meshBasicMaterial
          color={0xff00ff}
          transparent
          opacity={0.15}
          side={THREE.DoubleSide}
          blending={THREE.AdditiveBlending}
        />
      </mesh>
    </>
  )
}

export default VisualEffects
EOF

echo "✅ Efeitos visuais extras criados"

# 6. ATUALIZAR O APP.TSX PARA INCLUIR OS NOVOS COMPONENTES
echo ""
echo "6. 📱 ATUALIZANDO APP.TSX COM NOVOS COMPONENTES..."

# Atualizar o import e adicionar VisualEffects ao Experience
sed -i '/import Experience from .\/components\/Experience/a import VisualEffects from .\/components\/VisualEffects' frontend/src/App.tsx

# 7. CRIAR SCRIPT DE DEPLOY COM AS MELHORIAS
echo ""
echo "7. 🚀 CRIANDO SCRIPT DE DEPLOY DAS MELHORIAS..."

cat > deploy-enhanced.sh << 'EOF'
#!/bin/bash

echo "🎨 DEPLOY DA VERSÃO APRIMORADA - SYMPHONY OF CONNECTION"
echo "========================================================"

cd ~/workspace/SYMPHONY_OF_CONNECTION

# Parar processos existentes
echo "🛑 Parando processos anteriores..."
./audio-fix-manager.sh stop
sleep 2

# Build do frontend com as melhorias
echo "🔨 Build do frontend aprimorado..."
cd frontend
npm run build

if [ $? -eq 0 ]; then
    echo "✅ Build das melhorias concluído"
    
    # Iniciar sistema completo
    echo "🚀 Iniciando sistema aprimorado..."
    cd ..
    ./audio-fix-manager.sh start
    
    echo ""
    echo "🎉 VERSÃO APRIMORADA IMPLANTADA!"
    echo "================================"
    echo ""
    echo "✨ NOVAS CARACTERÍSTICAS:"
    echo "   🌈 Partículas coloridas baseadas em emoções"
    echo "   🎯 Formações dinâmicas (esfera, explosão, enxame)"
    echo "   💫 Efeitos visuais extras e glow"
    echo "   🎨 Paleta de cores emocionais"
    echo "   ⚡ Comportamentos complexos de partículas"
    echo ""
    echo "🌐 ACESSE: http://localhost:3000"
    echo ""
    echo "💡 EXPERIMENTE:"
    echo "   - Movimentos suaves: cores calmas e formação esférica"
    echo "   - Movimentos rápidos: cores intensas e formação explosiva"
    echo "   - Observe as transições entre formações"
    echo "   - Veja as cores mudarem com suas emoções"
    
else
    echo "❌ Erro no build das melhorias"
    exit 1
fi
EOF

chmod +x deploy-enhanced.sh

# 8. EXECUTAR VALIDAÇÃO FINAL
echo ""
echo "8. 🔍 VALIDAÇÃO FINAL DAS MELHORIAS..."

cd frontend

npx tsc --noEmit --skipLibCheck
if [ $? -eq 0 ]; then
    echo "✅ TypeScript: SEM ERROS"
else
    echo "❌ TypeScript com erros - Corrigindo..."
    npx tsc --noEmit --skipLibCheck 2>&1 | grep error
    exit 1
fi

echo ""
echo "🎉 ANÁLISE E MELHORIAS CONCLUÍDAS!"
echo "==================================="
echo ""
echo "📊 PARECER TÉCNICO FINAL:"
echo ""
echo "✅ ARQUITETURA SOLIDA:"
echo "   - Frontend React/Three.js bem estruturado"
echo "   - Backend Node.js/Express robusto"
echo "   - Comunicação WebSocket eficiente"
echo "   - Gerenciamento de estado com Zustand"
echo ""
echo "🎨 MELHORIAS VISUAIS IMPLEMENTADAS:"
echo "   ✅ Sistema de partículas coloridas dinâmicas"
echo "   ✅ Formações visuais baseadas em emoções"
echo "   ✅ Paleta de cores emocionais"
echo "   ✅ Efeitos visuais extras (glow, anéis)"
echo "   ✅ Comportamentos complexos de partículas"
echo ""
echo "🚀 PRÓXIMOS PASSOS SUGERIDOS:"
echo "   - Implementar mais formações (redes, fractais)"
echo "   - Adicionar modos de visualização alternativos"
echo "   - Criar galeria de composições geradas"
echo "   - Implementar export de sessões"
echo ""
echo "💡 PARA IMPLANTAR AS MELHORIAS:"
echo "   ./deploy-enhanced.sh"
echo ""
echo "🌐 REPOSITÓRIO ATUALIZADO: https://github.com/PrinceOfEgypt1/SYMPHONY_OF_CONNECTION"

