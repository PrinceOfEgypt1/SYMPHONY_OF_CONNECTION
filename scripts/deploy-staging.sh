#!/bin/bash

echo "🚀 IMPLANTANDO SYMPHONY OF CONNECTION EM STAGING..."
echo "==================================================="

cd ~/workspace/SYMPHONY_OF_CONNECTION

# Parar processos existentes
echo "🛑 Parando processos existentes..."
pkill -f "node.*server" 2>/dev/null || true
pkill -f "vite" 2>/dev/null || true

# Build do backend
echo ""
echo "🔨 CONSTRUINDO BACKEND..."
cd backend

# Instalar dependências se necessário
if [ ! -d "node_modules" ]; then
    echo "📦 Instalando dependências do backend..."
    npm install
fi

# Build TypeScript
echo "⚙️ Compilando TypeScript..."
npm run build

if [ $? -ne 0 ]; then
    echo "❌ Erro na compilação do backend"
    exit 1
fi

# Build do frontend
echo ""
echo "🔨 CONSTRUINDO FRONTEND..."
cd ../frontend

# Instalar dependências se necessário
if [ ! -d "node_modules" ]; then
    echo "📦 Instalando dependências do frontend..."
    npm install
fi

# Build de produção
echo "⚙️ Criando build de produção..."
npm run build

if [ $? -ne 0 ]; then
    echo "❌ Erro no build do frontend"
    exit 1
fi

# Iniciar serviços
echo ""
echo "🚀 INICIANDO SERVIÇOS EM STAGING..."

# Iniciar backend em background
cd ../backend
echo "🌐 Iniciando backend na porta 5000..."
npm start &
BACKEND_PID=$!
echo "📊 Backend PID: $BACKEND_PID"

# Aguardar backend inicializar
sleep 5

# Iniciar frontend em background
cd ../frontend
echo "🎨 Iniciando frontend na porta 3000..."
npm run dev &
FRONTEND_PID=$!
echo "📊 Frontend PID: $FRONTEND_PID"

# Aguardar inicialização completa
sleep 8

# Verificação final
echo ""
echo "✅ VERIFICAÇÃO FINAL DO DEPLOY:"

# Testar backend
if curl -s http://localhost:5000/health > /dev/null; then
    echo "✅ Backend: RESPONDENDO"
    BACKEND_STATUS=$(curl -s http://localhost:5000/health | jq -r '.status')
    echo "   Status: $BACKEND_STATUS"
else
    echo "❌ Backend: NÃO RESPONDE"
    exit 1
fi

# Testar frontend
if curl -s http://localhost:3000 > /dev/null; then
    echo "✅ Frontend: RESPONDENDO"
    echo "   URL: http://localhost:3000"
else
    echo "❌ Frontend: NÃO RESPONDE"
    exit 1
fi

echo ""
echo "🎉 DEPLOY EM STAGING CONCLUÍDO COM SUCESSO!"
echo "🌐 Frontend: http://localhost:3000"
echo "🔧 Backend:  http://localhost:5000"
echo "📊 Health:   http://localhost:5000/health"

# Salvar PIDs para gerenciamento futuro
echo $BACKEND_PID > /tmp/symphony-backend.pid
echo $FRONTEND_PID > /tmp/symphony-frontend.pid

echo ""
echo "💡 Use os seguintes comandos para gerenciar:"
echo "   Para parar: pkill -f 'node.*SYMPHONY'"
echo "   Para logs: tail -f backend/logs/app.log"
