/**
 * @file symphonyStore.ts
 * @description Gerenciamento de estado global da aplicação Symphony of Connection
 * @version 1.0.0
 * @author Symphony of Connection Team
 */

import { create } from 'zustand'

/**
 * @interface EmotionalVector
 * @description Representa o vetor emocional de 7 dimensões do usuário
 * @property {number} joy - Nível de alegria (0-1)
 * @property {number} excitement - Nível de excitação (0-1)
 * @property {number} calm - Nível de calma (0-1)
 * @property {number} curiosity - Nível de curiosidade (0-1)
 * @property {number} intensity - Intensidade emocional (0-1)
 * @property {number} fluidity - Fluidez do movimento (0-1)
 * @property {number} connection - Nível de conexão com outros (0-1)
 */
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
