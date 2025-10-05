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
