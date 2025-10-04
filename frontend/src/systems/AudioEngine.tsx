import { useEffect, useRef } from 'react'
import * as Tone from 'tone'
import { useSymphonyStore } from '../stores/symphonyStore'

export const AudioEngine: React.FC = () => {
  const { emotionalVector, mouseIntensity } = useSymphonyStore()
  const synthRef = useRef<Tone.PolySynth | null>(null)
  const reverbRef = useRef<Tone.Reverb | null>(null)
  const filterRef = useRef<Tone.Filter | null>(null)

  useEffect(() => {
    synthRef.current = new Tone.PolySynth(Tone.Synth, {
      oscillator: {
        type: 'sine'
      },
      envelope: {
        attack: 0.02,
        decay: 0.1,
        sustain: 0.3,
        release: 1
      }
    }).toDestination()

    reverbRef.current = new Tone.Reverb({
      decay: 2,
      wet: 0.3
    }).toDestination()

    filterRef.current = new Tone.Filter({
      frequency: 800,
      type: 'lowpass',
      Q: 1
    })

    synthRef.current.connect(filterRef.current)
    filterRef.current.connect(reverbRef.current)

    const handleFirstClick = async () => {
      await Tone.start()
      console.log('Áudio iniciado')
      document.removeEventListener('click', handleFirstClick)
    }

    document.addEventListener('click', handleFirstClick)

    return () => {
      synthRef.current?.dispose()
      reverbRef.current?.dispose()
      filterRef.current?.dispose()
      document.removeEventListener('click', handleFirstClick)
    }
  }, [])

  useEffect(() => {
    if (!synthRef.current) return

    const { calm, intensity } = emotionalVector
    
    const rhythm = Math.max(0.1, intensity * 2)
    
    if (mouseIntensity > 0.3 && Math.random() < rhythm) {
      const notes = ['C4', 'E4', 'G4', 'B4', 'D5']
      const note = notes[Math.floor(Math.random() * notes.length)]
      
      synthRef.current.triggerAttackRelease(note, '8n')
    }

    if (filterRef.current) {
      filterRef.current.frequency.value = 200 + (calm * 1000)
    }

  }, [emotionalVector, mouseIntensity])

  return null
}
