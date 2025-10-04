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
