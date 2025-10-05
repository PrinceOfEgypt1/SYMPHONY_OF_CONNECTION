/**
 * Sistema de áudio generativo baseado no estado emocional
 * @component
 * @description Gera música procedural baseada no vetor emocional coletivo
 */

import React, { useEffect, useRef, useCallback, useState } from 'react'
import * as Tone from 'tone'
import { useSymphonyStore } from '../stores/symphonyStore'
import { EmotionalVector } from '../types/symphony'

const AudioEngine: React.FC = () => {
  const { emotionalVector } = useSymphonyStore()
  const synthRef = useRef<Tone.PolySynth | null>(null)
  const sequenceRef = useRef<Tone.Sequence | null>(null)
  const lastPlayTimeRef = useRef<number>(0)
  const [audioInitialized, setAudioInitialized] = useState(false)
  const [userInteracted, setUserInteracted] = useState(false)

  // Aguardar interação do usuário para inicializar áudio
  useEffect(() => {
    const handleUserInteraction = async () => {
      if (!userInteracted) {
        console.log('🎵 Inicializando áudio após interação do usuário...')
        await Tone.start()
        console.log('✅ Contexto de áudio inicializado')
        setUserInteracted(true)
        initializeAudio()
      }
    }

    // Adicionar listeners para interações do usuário
    const events = ['click', 'touchstart', 'keydown', 'mousemove']
    events.forEach(event => {
      document.addEventListener(event, handleUserInteraction, { once: true })
    })

    return () => {
      events.forEach(event => {
        document.removeEventListener(event, handleUserInteraction)
      })
    }
  }, [userInteracted])

  // Inicialização do sistema de áudio
  const initializeAudio = async () => {
    try {
      console.log('🎵 Inicializando AudioEngine...')
      
      // Criar sintetizador
      synthRef.current = new Tone.PolySynth(Tone.Synth, {
        oscillator: {
          type: 'sine'
        },
        envelope: {
          attack: 0.02,
          decay: 0.1,
          sustain: 0.3,
          release: 1.2
        },
        volume: -10
      })

      // Configurar efeitos
      const reverb = new Tone.Reverb({
        decay: 2,
        wet: 0.4
      })

      const filter = new Tone.Filter(1200, "lowpass")
      const delay = new Tone.FeedbackDelay("8n", 0.3)

      // Conectar a cadeia de efeitos
      synthRef.current.chain(filter, delay, reverb, Tone.Destination)

      // Configurar transporte
      Tone.Transport.bpm.value = 80
      Tone.Transport.start()

      setAudioInitialized(true)
      console.log('✅ AudioEngine inicializado com sucesso')

    } catch (error) {
      console.error('❌ Erro na inicialização do áudio:', error)
    }
  }

  // Mapear emoções para parâmetros musicais
  const mapEmotionsToMusic = useCallback((vector: EmotionalVector) => {
    if (!vector) return null

    // VALORES SEGUROS - CORREÇÃO CRÍTICA
    const safeCalm = Math.max(0.02, Math.min(1, vector.calm))
    const safeIntensity = Math.max(0.1, Math.min(1, vector.intensity))
    const safeJoy = Math.max(0.3, Math.min(1, vector.joy))
    const safeFluidity = Math.max(0.2, Math.min(1, vector.fluidity))
    const safeCuriosity = Math.max(0.1, Math.min(1, vector.curiosity))

    // Escalas baseadas nas emoções
    const scales = {
      joyful: ['C4', 'E4', 'G4', 'B4', 'D5'],
      calm: ['C4', 'D4', 'F4', 'A4', 'C5'],
      intense: ['C4', 'F4', 'G4', 'Bb4', 'D5'],
      curious: ['C4', 'Eb4', 'G4', 'A4', 'Bb4']
    }

    // Selecionar escala baseada no vetor emocional
    let selectedScale: string[]
    if (safeJoy > 0.6) {
      selectedScale = scales.joyful
    } else if (safeCalm > 0.6) {
      selectedScale = scales.calm
    } else if (safeCuriosity > 0.6) {
      selectedScale = scales.curious
    } else {
      selectedScale = scales.intense
    }

    // Parâmetros do sintetizador
    if (synthRef.current) {
      synthRef.current.set({
        oscillator: {
          type: safeCalm > 0.5 ? 'sine' : 'sawtooth'
        },
        envelope: {
          attack: 0.02 + (1 - safeIntensity) * 0.1,
          decay: 0.1 + (1 - safeFluidity) * 0.3,
          sustain: 0.3 + safeJoy * 0.4,
          release: 0.5 + safeCalm * 1.0
        }
      })
    }

    return {
      scale: selectedScale,
      rhythm: Math.max(0.2, safeIntensity),
      volume: -15 + (safeIntensity * 15),
      noteDuration: 0.2 + (1 - safeFluidity) * 0.3,
      curiosity: safeCuriosity
    }
  }, [])

  // Gerar notas baseadas no estado emocional
  useEffect(() => {
    if (!emotionalVector || !synthRef.current || !audioInitialized) return

    const musicParams = mapEmotionsToMusic(emotionalVector)
    if (!musicParams) return

    const now = Date.now()

    // Tocar notas baseadas na intensidade
    if (now - lastPlayTimeRef.current > (1000 / (musicParams.rhythm * 8))) {
      try {
        const randomNote = musicParams.scale[
          Math.floor(Math.random() * musicParams.scale.length)
        ]

        // Tocar acorde baseado na conexão emocional
        if (emotionalVector.connection > 0.7) {
          const chordNotes = [
            musicParams.scale[0],
            musicParams.scale[2],
            musicParams.scale[4] || musicParams.scale[3]
          ]
          chordNotes.forEach((note, index) => {
            setTimeout(() => {
              synthRef.current?.triggerAttackRelease(note, musicParams.noteDuration * 0.8)
            }, index * 50)
          })
        } else {
          synthRef.current.triggerAttackRelease(randomNote, musicParams.noteDuration)
        }

        lastPlayTimeRef.current = now
      } catch (error) {
        console.error('❌ Erro ao tocar nota:', error)
      }
    }
  }, [emotionalVector, mapEmotionsToMusic, audioInitialized])

  // Cleanup
  useEffect(() => {
    return () => {
      console.log('🧹 Limpando AudioEngine...')
      sequenceRef.current?.dispose()
      synthRef.current?.dispose()
      Tone.Transport.stop()
    }
  }, [])

  // Componente de overlay para solicitar interação
  if (!userInteracted) {
    return (
      <div className="audio-permission-overlay">
        <div className="audio-permission-content">
          <div className="audio-icon">🎵</div>
          <h3>Clique para ativar o áudio</h3>
          <p>Toque em qualquer lugar da tela para iniciar a experiência musical</p>
          <button className="activate-audio-btn">
            Ativar Som
          </button>
        </div>
      </div>
    )
  }

  return null
}

export default AudioEngine
