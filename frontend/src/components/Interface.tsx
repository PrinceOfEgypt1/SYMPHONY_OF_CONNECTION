import React from 'react'
import { motion } from 'framer-motion'
import { useSymphonyStore } from '../stores/symphonyStore'

const Interface: React.FC = () => {
  const { 
    emotionalVector, 
    audioEnabled, 
    setAudioEnabled,
    isConnected,
    getConnectionStrength
  } = useSymphonyStore()

  const connectionStrength = getConnectionStrength()

  return (
    <div className="interface">
      {/* Status de conexão */}
      <div className="connection-status">
        <div className={`status-indicator ${isConnected ? 'connected' : 'disconnected'}`}>
          {isConnected ? '🔗 Conectado' : '🔌 Desconectado'}
        </div>
        <div className="connection-strength">
          Força da Conexão: {Math.round(connectionStrength * 100)}%
        </div>
      </div>

      {/* Controle de áudio */}
      <div className="audio-control">
        <button 
          className={`audio-toggle ${audioEnabled ? 'enabled' : 'disabled'}`}
          onClick={() => setAudioEnabled(!audioEnabled)}
        >
          {audioEnabled ? '🔊 Áudio Ativo' : '🔇 Áudio Mudo'}
        </button>
      </div>

      {/* Métricas emocionais */}
      <div className="emotional-metrics">
        <h3>Estado Emocional</h3>
        <div className="metrics-grid">
          {Object.entries(emotionalVector).map(([key, value]) => (
            <div key={key} className="metric">
              <div className="metric-header">
                <span className="metric-name">
                  {key.charAt(0).toUpperCase() + key.slice(1)}
                </span>
                <span className="metric-value">
                  {Math.round(Number(value) * 100)}%
                </span>
              </div>
              <motion.div 
                className="metric-bar"
                animate={{ width: `${Number(value) * 100}%` }}
                transition={{ type: "spring", damping: 20 }}
              />
            </div>
          ))}
        </div>
      </div>

      {/* Instruções */}
      <div className="instructions">
        <p>🎵 Mova o mouse para criar música e partículas</p>
        <p>✨ Observe as constelações de outros usuários</p>
        <p>🌐 Conecte-se emocionalmente com outros</p>
      </div>
    </div>
  )
}

export default Interface
