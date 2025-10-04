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

// ... resto do código existente ...
