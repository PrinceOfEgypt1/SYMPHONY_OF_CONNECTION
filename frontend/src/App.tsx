import React, { useState, useEffect } from 'react'
import { Canvas } from '@react-three/fiber'
import { useSymphonyStore } from './stores/symphonyStore'
import Experience from './components/Experience'
import AudioEngine from './systems/AudioEngine'
import './App.css'

/**
 * Componente principal da aplicação
 * @component
 * @description Interface moderna e responsiva para Symphony of Connection
 */
const App: React.FC = () => {
  const { emotionalVector } = useSymphonyStore() // Apenas emotionalVector existe na store
  const [isLoading, setIsLoading] = useState(true)
  const [showInstructions, setShowInstructions] = useState(true)
  const [connectedUsers, setConnectedUsers] = useState(1) // Estado local para usuários

  useEffect(() => {
    // Simular loading inicial
    const timer = setTimeout(() => setIsLoading(false), 2000)
    
    // Simular usuários conectados (para demonstração)
    const userInterval = setInterval(() => {
      setConnectedUsers(prev => Math.max(1, prev + Math.floor(Math.random() * 3) - 1))
    }, 5000)
    
    return () => {
      clearTimeout(timer)
      clearInterval(userInterval)
    }
  }, [])

  if (isLoading) {
    return (
      <div className="loading-screen">
        <div className="loading-content">
          <div className="logo">
            <div className="logo-icon">🎵</div>
            <h1>Symphony of Connection</h1>
          </div>
          <div className="loading-spinner"></div>
          <p>Inicializando experiência generativa...</p>
        </div>
      </div>
    )
  }

  return (
    <div className="app">
      {/* Header Moderno */}
      <header className="header">
        <div className="header-content">
          <div className="brand">
            <div className="logo">🎵</div>
            <h1>Symphony of Connection</h1>
          </div>
          <div className="controls">
            <button 
              className="icon-button"
              onClick={() => setShowInstructions(!showInstructions)}
              title="Instruções"
            >
              💡
            </button>
            <div className="user-count">
              👥 {connectedUsers} conectados
            </div>
          </div>
        </div>
      </header>

      {/* Painel de Instruções */}
      {showInstructions && (
        <div className="instructions-panel">
          <div className="instructions-content">
            <h3>🎵 Como Jogar</h3>
            <ul>
              <li>🎮 <strong>Mova o mouse</strong> para criar música e partículas</li>
              <li>🎨 <strong>Movimentos suaves</strong> geram melodias calmas</li>
              <li>⚡ <strong>Movimentos rápidos</strong> criam ritmos intensos</li>
              <li>🌐 <strong>Conecte-se</strong> com outros usuários em tempo real</li>
              <li>🎧 <strong>Use fones de ouvido</strong> para melhor experiência</li>
            </ul>
            <button 
              className="close-button"
              onClick={() => setShowInstructions(false)}
            >
              Fechar
            </button>
          </div>
        </div>
      )}

      {/* Canvas 3D Principal */}
      <main className="main-content">
        <Canvas
          camera={{ position: [0, 0, 5], fov: 75 }}
          className="experience-canvas"
        >
          <color attach="background" args={['#0f0f23']} />
          <fog attach="fog" args={['#0f0f23', 5, 15]} />
          <Experience />
        </Canvas>
      </main>

      {/* Painel de Status Emocional */}
      <div className="emotional-panel">
        <div className="panel-content">
          <h4>Estado Emocional</h4>
          <div className="emotional-bars">
            <div className="emotional-bar">
              <span>😊 Alegria</span>
              <div className="bar-container">
                <div 
                  className="bar-fill joy" 
                  style={{ width: `${(emotionalVector?.joy || 0) * 100}%` }}
                ></div>
              </div>
            </div>
            <div className="emotional-bar">
              <span>⚡ Excitação</span>
              <div className="bar-container">
                <div 
                  className="bar-fill excitement" 
                  style={{ width: `${(emotionalVector?.excitement || 0) * 100}%` }}
                ></div>
              </div>
            </div>
            <div className="emotional-bar">
              <span>😌 Calma</span>
              <div className="bar-container">
                <div 
                  className="bar-fill calm" 
                  style={{ width: `${(emotionalVector?.calm || 0) * 100}%` }}
                ></div>
              </div>
            </div>
            <div className="emotional-bar">
              <span>🔗 Conexão</span>
              <div className="bar-container">
                <div 
                  className="bar-fill connection" 
                  style={{ width: `${(emotionalVector?.connection || 0) * 100}%` }}
                ></div>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Footer */}
      <footer className="footer">
        <div className="footer-content">
          <p>🎵 Movimente o mouse para criar música generativa em tempo real</p>
          <div className="audio-indicator">
            <span className="pulse"></span>
            Sistema de Áudio Ativo
          </div>
        </div>
      </footer>

      {/* Sistema de Áudio */}
      <AudioEngine />
    </div>
  )
}

export default App
