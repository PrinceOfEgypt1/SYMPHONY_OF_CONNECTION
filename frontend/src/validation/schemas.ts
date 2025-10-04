/**
 * @file schemas.ts
 * @description Schemas de validação Zod para dados da aplicação
 * @version 1.0.0
 */

import { z } from 'zod'

/**
 * @schema EmotionalVectorSchema
 * @description Validação para vetor emocional de 7 dimensões
 */
export const EmotionalVectorSchema = z.object({
  joy: z.number().min(0).max(1),
  excitement: z.number().min(0).max(1),
  calm: z.number().min(0).max(1),
  curiosity: z.number().min(0).max(1),
  intensity: z.number().min(0).max(1),
  fluidity: z.number().min(0).max(1),
  connection: z.number().min(0).max(1),
})

/**
 * @schema UserStateSchema  
 * @description Validação para estado do usuário
 */
export const UserStateSchema = z.object({
  id: z.string(),
  emotionalVector: EmotionalVectorSchema,
  position: z.tuple([z.number(), z.number(), z.number()]),
  color: z.string(),
  connected: z.boolean()
})
