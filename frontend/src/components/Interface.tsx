import { motion } from 'framer-motion'
import { useSymphonyStore } from '../stores/symphonyStore'

export const Interface: React.FC = () => {
  const { emotionalVector, audioEnabled, setAudioEnabled } = useSymphonyStore()

  const emotionLabels: { [key: string]: string } = {
    joy: 'Alegria',
    excitement: 'Excitação',
    calm: 'Calma',
    curiosity: 'Curiosidade',
    intensity: 'Intensidade',
    fluidity: 'Fluidez',
    connection: 'Conexão'
  }

  return (
    <div style={{
      position: 'fixed',
      top: 0,
      left: 0,
      width: '100%',
      padding: '20px',
      color: 'white',
      fontFamily: 'Arial, sans-serif',
      pointerEvents: 'none',
      zIndex: 1000
    }}>
      <motion.div
        initial={{ opacity: 0, y: -20 }}
        animate={{ opacity: 1, y: 0 }}
        style={{
          display: 'flex',
          justifyContent: 'space-between',
          alignItems: 'flex-start'
        }}
      >
        <div>
          <h1 style={{ margin: 0, fontSize: '24px', fontWeight: 'bold' }}>
            🎵 Symphony of Connection
          </h1>
          <p style={{ margin: '5px 0 0 0', opacity: 0.8 }}>
            Mova o mouse para criar música e emoções visuais
          </p>
        </div>
        
        <motion.button
          onClick={() => setAudioEnabled(!audioEnabled)}
          style={{
            pointerEvents: 'auto',
            background: 'rgba(255, 255, 255, 0.1)',
            border: '1px solid rgba(255, 255, 255, 0.3)',
            color: 'white',
            padding: '8px 16px',
            borderRadius: '20px',
            cursor: 'pointer',
            backdropFilter: 'blur(10px)'
          }}
          whileHover={{ scale: 1.05 }}
          whileTap={{ scale: 0.95 }}
        >
          {audioEnabled ? '🔊 Áudio Ativo' : '🔇 Áudio Mudo'}
        </motion.button>
      </motion.div>

      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.5 }}
        style={{
          position: 'fixed',
          bottom: '20px',
          left: '20px',
          background: 'rgba(0, 0, 0, 0.5)',
          padding: '15px',
          borderRadius: '10px',
          backdropFilter: 'blur(10px)',
          border: '1px solid rgba(255, 255, 255, 0.1)'
        }}
      >
        <h3 style={{ margin: '0 0 10px 0', fontSize: '14px', opacity: 0.8 }}>
          Estado Emocional
        </h3>
        
        {Object.entries(emotionalVector).map(([emotion, value]) => (
          <div key={emotion} style={{ marginBottom: '5px' }}>
            <div style={{
              display: 'flex',
              justifyContent: 'space-between',
              fontSize: '12px',
              marginBottom: '2px'
            }}>
              <span style={{ textTransform: 'capitalize' }}>
                {emotionLabels[emotion] || emotion}:
              </span>
              <span>
                {Math.round(value * 100)}%
              </span>
            </div>
            <div style={{
              width: '150px',
              height: '4px',
              background: 'rgba(255, 255, 255, 0.2)',
              borderRadius: '2px',
              overflow: 'hidden'
            }}>
              <motion.div
                initial={{ width: 0 }}
                animate={{ width: `${value * 100}%` }}
                transition={{ duration: 0.5 }}
                style={{
                  height: '100%',
                  background: `linear-gradient(90deg, #ff6b6b, #4ecdc4)`,
                  borderRadius: '2px'
                }}
              />
            </div>
          </div>
        ))}
      </motion.div>

      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ delay: 1 }}
        style={{
          position: 'fixed',
          bottom: '20px',
          right: '20px',
          textAlign: 'right',
          fontSize: '12px',
          opacity: 0.6
        }}
      >
        <div>🎮 Movimento do mouse = Intensidade emocional</div>
        <div>🎵 Velocidade = Ritmo musical</div>
        <div>🌈 Padrões = Harmonia visual</div>
      </motion.div>
    </div>
  )
}
