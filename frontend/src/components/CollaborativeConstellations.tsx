/**
 * Componente de Constelações Colaborativas
 * Visualização 3D de outros usuários na sinfonia
 * @component
 */

import React, { useMemo } from 'react';
import { useThree } from '@react-three/fiber';
import { useSymphonyStore } from '../stores/symphonyStore';

/**
 * Componente que renderiza constelações representando outros usuários
 */
const CollaborativeConstellations: React.FC = () => {
  const { getOtherUsers } = useSymphonyStore();
  const { size } = useThree();

  const otherUsers = getOtherUsers();

  const normalizedUsers = useMemo(() => {
    return otherUsers.map(user => ({
      ...user,
      // Normalizar posição para coordenadas 3D baseada no tamanho da tela
      normalizedPosition: [
        (user.position[0] / size.width) * 20 - 10,  // X: -10 to 10
        -(user.position[1] / size.height) * 20 + 10, // Y: -10 to 10  
        user.position[2] || -2                       // Z: behind main particles
      ] as [number, number, number]
    }));
  }, [otherUsers, size]);

  if (otherUsers.length === 0) {
    return null;
  }

  return (
    <>
      {normalizedUsers.map((user) => (
        <group key={user.id} position={user.normalizedPosition}>
          {/* Partículas da constelação baseadas no vetor emocional */}
          <points>
            <bufferGeometry>
              <bufferAttribute
                attach="attributes-position"
                count={7} // 7 dimensões emocionais
                array={new Float32Array(
                  Object.values(user.emotionalVector).flatMap((value, index) => {
                    const angle = (index / 7) * Math.PI * 2;
                    const radius = value * 1.5 + 0.5; // Radius based on emotional intensity
                    return [
                      Math.cos(angle) * radius,
                      Math.sin(angle) * radius,
                      (Math.random() - 0.5) * 0.3
                    ];
                  })
                )}
                itemSize={3}
              />
            </bufferGeometry>
            <pointsMaterial 
              size={0.15} 
              color={user.color}
              transparent 
              opacity={0.8}
              sizeAttenuation={true}
            />
          </points>
          
          {/* Aura emocional sutil */}
          <mesh>
            <sphereGeometry args={[2, 8, 6]} />
            <meshBasicMaterial 
              color={user.color}
              transparent
              opacity={0.03}
              wireframe
            />
          </mesh>
          
          {/* Indicador de direção/orientação */}
          <mesh position={[0, 0, 0.3]}>
            <coneGeometry args={[0.3, 0.8, 4]} />
            <meshBasicMaterial 
              color={user.color} 
              transparent 
              opacity={0.6} 
            />
          </mesh>

          {/* Linhas de conexão entre partículas */}
          <line>
            <bufferGeometry>
              <bufferAttribute
                attach="attributes-position"
                count={7}
                array={new Float32Array(
                  Object.values(user.emotionalVector).flatMap((value, index) => {
                    const angle1 = (index / 7) * Math.PI * 2;
                    const angle2 = ((index + 1) % 7 / 7) * Math.PI * 2;
                    const radius1 = value * 1.5 + 0.5;
                    const nextValue = Object.values(user.emotionalVector)[(index + 1) % 7];
                    const radius2 = nextValue * 1.5 + 0.5;
                    
                    return [
                      Math.cos(angle1) * radius1,
                      Math.sin(angle1) * radius1,
                      (Math.random() - 0.5) * 0.3,
                      Math.cos(angle2) * radius2,
                      Math.sin(angle2) * radius2,
                      (Math.random() - 0.5) * 0.3
                    ];
                  })
                )}
                itemSize={3}
              />
            </bufferGeometry>
            <lineBasicMaterial 
              color={user.color} 
              transparent 
              opacity={0.4}
              linewidth={1}
            />
          </line>
        </group>
      ))}
    </>
  );
};

export default CollaborativeConstellations;
