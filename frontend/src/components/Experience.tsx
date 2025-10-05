import React, { useRef, useEffect } from 'react'
import { useFrame, useThree } from '@react-three/fiber'
import * as THREE from 'three'
import { useSymphonyStore } from '../stores/symphonyStore'
import CollaborativeConstellations from './CollaborativeConstellations'

/**
 * Componente principal de experiência 3D
 * @component
 * @description Gerencia partículas, interações e renderização 3D com visual melhorado
 */
const Experience: React.FC = () => {
  const particlesRef = useRef<THREE.Points>(null)
  const ambientLightRef = useRef<THREE.AmbientLight>(null)
  const pointLightRef = useRef<THREE.PointLight>(null)
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

  // Geometria das partículas melhorada
  const particleGeometry = React.useMemo(() => {
    const geometry = new THREE.BufferGeometry()
    const count = 1000 // Mais partículas para efeito mais rico
    const positions = new Float32Array(count * 3)
    const colors = new Float32Array(count * 3)
    const sizes = new Float32Array(count)

    for (let i = 0; i < count * 3; i += 3) {
      // Posições em uma esfera maior
      const radius = 8 + Math.random() * 4
      const theta = Math.random() * Math.PI * 2
      const phi = Math.acos(2 * Math.random() - 1)
      
      positions[i] = radius * Math.sin(phi) * Math.cos(theta)
      positions[i + 1] = radius * Math.sin(phi) * Math.sin(theta)
      positions[i + 2] = radius * Math.cos(phi)

      // Cores gradientes
      const color = new THREE.Color()
      color.setHSL(Math.random() * 0.2 + 0.5, 0.8, 0.6 + Math.random() * 0.2)
      colors[i] = color.r
      colors[i + 1] = color.g
      colors[i + 2] = color.b

      // Tamanhos variados
      sizes[i / 3] = Math.random() * 0.1 + 0.05
    }

    geometry.setAttribute('position', new THREE.BufferAttribute(positions, 3))
    geometry.setAttribute('color', new THREE.BufferAttribute(colors, 3))
    geometry.setAttribute('size', new THREE.BufferAttribute(sizes, 1))
    
    return geometry
  }, [])

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

    // Animar partículas com movimento mais orgânico
    const particles = particlesRef.current
    const positions = particles.geometry.attributes.position.array as Float32Array
    const colors = particles.geometry.attributes.color.array as Float32Array
    
    for (let i = 0; i < positions.length; i += 3) {
      // Movimento de fluxo suave com noise
      const particleIndex = i / 3
      const noise = Math.sin(time * 0.5 + particleIndex * 0.1)
      const noise2 = Math.cos(time * 0.3 + particleIndex * 0.05)
      
      positions[i] += noise * 0.005
      positions[i + 1] += noise2 * 0.005
      positions[i + 2] += (noise + noise2) * 0.003

      // Pulsação suave de cores
      const hue = (0.5 + Math.sin(time * 0.2 + particleIndex * 0.01) * 0.1) % 1
      const color = new THREE.Color().setHSL(hue, 0.8, 0.6)
      colors[i] = color.r
      colors[i + 1] = color.g
      colors[i + 2] = color.b
    }
    
    particles.geometry.attributes.position.needsUpdate = true
    particles.geometry.attributes.color.needsUpdate = true

    // Animar luzes baseado no movimento
    if (pointLightRef.current) {
      pointLightRef.current.position.x = Math.sin(time * 0.5) * 3
      pointLightRef.current.position.y = Math.cos(time * 0.3) * 2
      pointLightRef.current.intensity = 1 + intensity * 2
    }
  })

  return (
    <>
      {/* Iluminação melhorada */}
      <ambientLight ref={ambientLightRef} intensity={0.3} />
      <pointLight 
        ref={pointLightRef} 
        position={[2, 2, 2]} 
        intensity={1.5} 
        color="#8b5cf6"
        distance={20}
        decay={2}
      />
      <pointLight 
        position={[-2, -1, 1]} 
        intensity={0.8} 
        color="#ec4899"
        distance={15}
        decay={2}
      />

      {/* Partículas principais */}
      <points ref={particlesRef}>
        <primitive object={particleGeometry} />
        <pointsMaterial 
          size={0.08}
          vertexColors={true}
          transparent
          opacity={0.8}
          sizeAttenuation={true}
          blending={THREE.AdditiveBlending}
        />
      </points>

      {/* Efeito de glow com partículas menores */}
      <points>
        <primitive object={particleGeometry.clone()} />
        <pointsMaterial 
          size={0.03}
          vertexColors={true}
          transparent
          opacity={0.4}
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
