import { useRef, useMemo, useEffect } from 'react'
import { useFrame, useThree } from '@react-three/fiber'
import * as THREE from 'three'
import { useSymphonyStore } from '../stores/symphonyStore'

export const Experience: React.FC = () => {
  const particlesRef = useRef<THREE.Points>(null)
  const { mousePosition, emotionalVector } = useSymphonyStore()
  const { size } = useThree()

  // Sistema de partículas
  const particleSystem = useMemo(() => {
    const particleCount = 2000
    const positions = new Float32Array(particleCount * 3)
    const colors = new Float32Array(particleCount * 3)
    const sizes = new Float32Array(particleCount)

    for (let i = 0; i < particleCount; i++) {
      const i3 = i * 3
      const radius = 4 + Math.random() * 2
      const theta = Math.random() * Math.PI * 2
      const phi = Math.acos(2 * Math.random() - 1)
      
      positions[i3] = radius * Math.sin(phi) * Math.cos(theta)
      positions[i3 + 1] = radius * Math.sin(phi) * Math.sin(theta)
      positions[i3 + 2] = radius * Math.cos(phi)
      
      colors[i3] = 0.5 + 0.5 * Math.sin(theta)
      colors[i3 + 1] = 0.5 + 0.5 * Math.cos(phi)
      colors[i3 + 2] = 0.5 + 0.5 * Math.sin(theta + phi)
      
      sizes[i] = 0.02 + Math.random() * 0.03
    }

    const geometry = new THREE.BufferGeometry()
    geometry.setAttribute('position', new THREE.BufferAttribute(positions, 3))
    geometry.setAttribute('color', new THREE.BufferAttribute(colors, 3))
    geometry.setAttribute('size', new THREE.BufferAttribute(sizes, 1))
    
    return geometry
  }, [])

  // Animação das partículas
  useFrame((state) => {
    if (particlesRef.current) {
      const time = state.clock.elapsedTime
      
      particlesRef.current.rotation.x = time * 0.05
      particlesRef.current.rotation.y = time * 0.03
      
      particlesRef.current.rotation.x += (mousePosition[1] * 0.5 - particlesRef.current.rotation.x) * 0.1
      particlesRef.current.rotation.y += (mousePosition[0] * 0.5 - particlesRef.current.rotation.y) * 0.1
      
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
      
      const intensity = Math.sqrt(x * x + y * y) * 2
      useSymphonyStore.getState().setMouseIntensity(intensity)
      
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
