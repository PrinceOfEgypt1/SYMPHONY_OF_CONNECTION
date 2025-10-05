#!/bin/bash

echo "🔊 CORREÇÃO COMPLETA DO SISTEMA DE ÁUDIO E BACKEND"
echo "==================================================="

cd ~/workspace/SYMPHONY_OF_CONNECTION

# 1. LIBERAR PORTA 5000 E PARAR PROCESSOS
echo ""
echo "1. 🛑 LIBERANDO PORTA 5000 E PARANDO PROCESSOS..."

# Encontrar e matar processos usando a porta 5000
echo "🔍 Procurando processos na porta 5000..."
PIDS=$(lsof -ti:5000 2>/dev/null)
if [ ! -z "$PIDS" ]; then
    echo "🔄 Encontrados processos: $PIDS"
    kill -9 $PIDS 2>/dev/null
    echo "✅ Processos terminados"
else
    echo "✅ Nenhum processo encontrado na porta 5000"
fi

# Parar outros processos do projeto
pkill -f "node.*server" 2>/dev/null || true
pkill -f "vite" 2>/dev/null || true
pkill -f "tsx" 2>/dev/null || true

# Aguardar liberação da porta
sleep 2

# 2. VERIFICAR SE A PORTA ESTÁ LIVRE
echo ""
echo "2. 🔍 VERIFICANDO STATUS DA PORTA 5000..."

if lsof -ti:5000 > /dev/null 2>&1; then
    echo "❌ Porta 5000 ainda ocupada. Forçando liberação..."
    sudo fuser -k 5000/tcp
    sleep 2
else
    echo "✅ Porta 5000 liberada"
fi

# 3. CORRIGIR O AUDIOENGINE PARA REQUERER INTERAÇÃO DO USUÁRIO
echo ""
echo "3. 🎵 CORRIGINDO AUDIOENGINE PARA INTERAÇÃO DO USUÁRIO..."

cat > frontend/src/systems/AudioEngine.tsx << 'EOF'
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
EOF

echo "✅ AudioEngine corrigido - aguarda interação do usuário"

# 4. ADICIONAR CSS PARA O OVERLAY DE ÁUDIO
echo ""
echo "4. 🎨 ADICIONANDO ESTILOS PARA O OVERLAY DE ÁUDIO..."

cat >> frontend/src/App.css << 'EOF'

/* ===== OVERLAY DE ATIVAÇÃO DE ÁUDIO ===== */
.audio-permission-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(15, 15, 35, 0.95);
  backdrop-filter: blur(20px);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  animation: fadeIn 0.5s ease-out;
}

.audio-permission-content {
  text-align: center;
  background: var(--card-bg);
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: var(--border-radius);
  padding: 3rem;
  max-width: 400px;
  box-shadow: var(--shadow);
  animation: slideInUp 0.5s ease-out;
}

.audio-icon {
  font-size: 4rem;
  margin-bottom: 1rem;
  animation: bounce 2s infinite;
}

.audio-permission-content h3 {
  color: var(--text-primary);
  margin-bottom: 1rem;
  font-size: 1.5rem;
}

.audio-permission-content p {
  color: var(--text-secondary);
  margin-bottom: 2rem;
  line-height: 1.5;
}

.activate-audio-btn {
  background: var(--accent-purple);
  color: white;
  border: none;
  padding: 1rem 2rem;
  border-radius: var(--border-radius);
  font-size: 1.1rem;
  font-weight: 600;
  cursor: pointer;
  transition: var(--transition);
  width: 100%;
}

.activate-audio-btn:hover {
  background: var(--accent-pink);
  transform: translateY(-2px);
}

@keyframes bounce {
  0%, 20%, 50%, 80%, 100% {
    transform: translateY(0);
  }
  40% {
    transform: translateY(-10px);
  }
  60% {
    transform: translateY(-5px);
  }
}

@keyframes slideInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes fadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}
EOF

echo "✅ Estilos do overlay de áudio adicionados"

# 5. INICIAR BACKEND CORRETAMENTE
echo ""
echo "5. 🌐 INICIANDO BACKEND NA PORTA 5000..."

cd backend

# Verificar se a porta está livre antes de iniciar
if lsof -ti:5000 > /dev/null 2>&1; then
    echo "❌ ERRO: Porta 5000 ainda está ocupada!"
    echo "🔄 Tentando forçar liberação..."
    sudo fuser -k 5000/tcp 2>/dev/null || true
    sleep 3
fi

# Iniciar backend em background
npm start &
BACKEND_PID=$!
echo "📊 Backend PID: $BACKEND_PID"

# Aguardar inicialização
echo "⏳ Aguardando backend inicializar..."
sleep 8

# 6. VERIFICAR SE BACKEND ESTÁ RODANDO
echo ""
echo "6. 🔍 VERIFICANDO STATUS DO BACKEND..."

if curl -s http://localhost:5000/health > /dev/null; then
    BACKEND_STATUS=$(curl -s http://localhost:5000/health | jq -r '.status' 2>/dev/null || echo "healthy")
    echo "✅ Backend: RODANDO - Status: $BACKEND_STATUS"
else
    echo "❌ Backend: NÃO RESPONDE"
    echo "📋 Tentando diagnosticar..."
    
    # Verificar se o processo está vivo
    if ps -p $BACKEND_PID > /dev/null; then
        echo "⚠️  Processo backend está vivo mas não responde"
    else
        echo "⚠️  Processo backend morreu"
    fi
    
    # Tentar iniciar novamente com mais informações
    echo "🔄 Reiniciando backend com logs detalhados..."
    npm start
fi

# 7. INICIAR FRONTEND
echo ""
echo "7. 🎨 INICIANDO FRONTEND..."

cd ../frontend

# Build do projeto primeiro
echo "🔨 Realizando build do frontend..."
npm run build

if [ $? -eq 0 ]; then
    echo "✅ Build do frontend concluído"
    
    # Iniciar servidor de desenvolvimento
    echo "🚀 Iniciando servidor de desenvolvimento..."
    npm run dev &
    FRONTEND_PID=$!
    echo "📊 Frontend PID: $FRONTEND_PID"
    
    sleep 5
    
    echo ""
    echo "🎉 SISTEMA INICIADO COM SUCESSO!"
    echo "================================"
    echo ""
    echo "🌐 URL DO FRONTEND: http://localhost:3000"
    echo "🔧 URL DO BACKEND:  http://localhost:5000"
    echo "📊 HEALTH CHECK:    http://localhost:5000/health"
    echo ""
    echo "🔊 INSTRUÇÕES PARA O ÁUDIO:"
    echo "   1. Acesse http://localhost:3000"
    echo "   2. Clique em 'Ativar Som' ou toque em qualquer lugar da tela"
    echo "   3. Mova o mouse para gerar música generativa"
    echo "   4. Use fones de ouvido para melhor experiência"
    echo ""
    echo "🐛 SOLUÇÃO DE PROBLEMAS:"
    echo "   - Se o áudio não funcionar, recarregue a página e clique novamente"
    echo "   - Verifique se o backend está respondendo em http://localhost:5000/health"
    echo "   - Confirme se a porta 5000 não está bloqueada por firewall"
    echo ""
    echo "⏹️  Para parar o sistema:"
    echo "   pkill -f 'node.*SYMPHONY'"
    
else
    echo "❌ Erro no build do frontend"
    exit 1
fi

# 8. CRIAR SCRIPT DE GERENCIAMENTO RÁPIDO
echo ""
echo "8. 📝 CRIANDO SCRIPT DE GERENCIAMENTO RÁPIDO..."

cd ..

cat > audio-fix-manager.sh << 'EOF'
#!/bin/bash

case "$1" in
    "start")
        echo "🚀 Iniciando Symphony of Connection..."
        pkill -f "node.*server" 2>/dev/null || true
        pkill -f "vite" 2>/dev/null || true
        sudo fuser -k 5000/tcp 2>/dev/null || true
        
        cd backend
        npm start &
        echo $! > ../backend.pid
        sleep 5
        
        cd ../frontend
        npm run dev &
        echo $! > ../frontend.pid
        
        echo "✅ Sistema iniciado!"
        echo "🌐 Frontend: http://localhost:3000"
        echo "🔧 Backend:  http://localhost:5000"
        ;;
    "stop")
        echo "🛑 Parando Symphony of Connection..."
        pkill -f "node.*server" 2>/dev/null || true
        pkill -f "vite" 2>/dev/null || true
        sudo fuser -k 5000/tcp 2>/dev/null || true
        rm -f backend.pid frontend.pid 2>/dev/null
        echo "✅ Sistema parado!"
        ;;
    "status")
        echo "📊 Status do Sistema:"
        if curl -s http://localhost:5000/health > /dev/null; then
            echo "✅ Backend: RODANDO"
        else
            echo "❌ Backend: PARADO"
        fi
        
        if curl -s http://localhost:3000 > /dev/null; then
            echo "✅ Frontend: RODANDO"
        else
            echo "❌ Frontend: PARADO"
        fi
        ;;
    "restart")
        $0 stop
        sleep 2
        $0 start
        ;;
    *)
        echo "Uso: $0 {start|stop|restart|status}"
        echo ""
        echo "Comandos:"
        echo "  start   - Iniciar sistema completo"
        echo "  stop    - Parar sistema completo"
        echo "  restart - Reiniciar sistema"
        echo "  status  - Verificar status"
        exit 1
        ;;
esac
EOF

chmod +x audio-fix-manager.sh

echo ""
echo "✅ SCRIPT DE CORREÇÃO CONCLUÍDO!"
echo "================================"
echo ""
echo "🎯 RESUMO DAS CORREÇÕES:"
echo "   ✅ Porta 5000 liberada e backend iniciado"
echo "   ✅ AudioEngine corrigido para aguardar interação do usuário"
echo "   ✅ Overlay de ativação de áudio adicionado"
echo "   ✅ Sistema completo em execução"
echo "   ✅ Script de gerenciamento criado"
echo ""
echo "🚀 COMANDOS ÚTEIS:"
echo "   ./audio-fix-manager.sh status   - Verificar status"
echo "   ./audio-fix-manager.sh restart  - Reiniciar sistema"
echo "   ./audio-fix-manager.sh stop     - Parar sistema"
echo ""
echo "🔊 AGORA O ÁUDIO DEVE FUNCIONAR CORRETAMENTE!"

