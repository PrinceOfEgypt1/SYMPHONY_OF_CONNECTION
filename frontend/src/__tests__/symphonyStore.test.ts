/**
 * @file symphonyStore.test.ts
 * @description Testes básicos para o store principal
 */

import { useSymphonyStore } from '../stores/symphonyStore'

describe('Symphony Store', () => {
  test('initial emotional vector has valid values', () => {
    const store = useSymphonyStore.getState()
    
    expect(store.emotionalVector.joy).toBeGreaterThanOrEqual(0)
    expect(store.emotionalVector.joy).toBeLessThanOrEqual(1)
  })
})
