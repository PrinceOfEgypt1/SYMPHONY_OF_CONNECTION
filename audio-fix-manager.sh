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
