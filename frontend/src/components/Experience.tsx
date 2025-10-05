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
