#!/bin/bash

echo "🚀 DEPLOY RÁPIDO - SYMPHONY OF CONNECTION"
echo "=========================================="

# Parar processos existentes
echo "🛑 Parando processos..."
pkill -f "node.*server" 2>/dev/null || true
pkill -f "vite" 2>/dev/null || true

# Iniciar backend
echo "🌐 Iniciando backend..."
cd backend
npm start &
BACKEND_PID=$!
echo "📊 Backend PID: $BACKEND_PID"

# Aguardar backend
sleep 3

# Iniciar frontend
echo "🎨 Iniciando frontend..."
cd ../frontend
npm run dev &
FRONTEND_PID=$!
echo "📊 Frontend PID: $FRONTEND_PID"

echo ""
echo "⏳ Aguardando inicialização..."
sleep 5

echo ""
echo "✅ SISTEMA INICIADO!"
echo "🌐 Frontend: http://localhost:3000"
echo "🔧 Backend:  http://localhost:5000"
echo ""
echo "💡 Pressione Ctrl+C para parar os serviços"

# Manter script rodando
wait
