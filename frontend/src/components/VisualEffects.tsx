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
