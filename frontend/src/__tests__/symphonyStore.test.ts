import { useSymphonyStore } from '../stores/symphonyStore'

describe('Symphony Store', () => {
  it('should initialize with default values', () => {
    const state = useSymphonyStore.getState()
    
    expect(state.symphonyState).toBeNull()
    expect(state.currentUser).toBeNull()
    expect(state.isConnected).toBe(false)
    expect(state.audioEnabled).toBe(true)
  })

  it('should connect to symphony', () => {
    useSymphonyStore.getState().connectToSymphony()
    
    // Verificar se a conexão foi iniciada
    expect(useSymphonyStore.getState().isConnected).toBe(true)
  })

  it('should update emotional vector', () => {
    const emotionalVector = {
      joy: 0.8,
      excitement: 0.6,
      calm: 0.4,
      curiosity: 0.9,
      intensity: 0.7,
      fluidity: 0.5,
      connection: 0.8
    }

    useSymphonyStore.getState().updateEmotionalVector(emotionalVector)
    
    const { emotionalVector: currentVector } = useSymphonyStore.getState()
    expect(currentVector).toEqual(emotionalVector)
  })

  it('should get other users', () => {
    const otherUsers = useSymphonyStore.getState().getOtherUsers()
    
    expect(Array.isArray(otherUsers)).toBe(true)
  })

  it('should get connection strength', () => {
    const connectionStrength = useSymphonyStore.getState().getConnectionStrength()
    
    expect(typeof connectionStrength).toBe('number')
    expect(connectionStrength).toBeGreaterThanOrEqual(0)
    expect(connectionStrength).toBeLessThanOrEqual(1)
  })
})
