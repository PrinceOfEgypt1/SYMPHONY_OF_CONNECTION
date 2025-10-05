#!/bin/bash

echo "🎨 DEPLOY DA VERSÃO APRIMORADA - SYMPHONY OF CONNECTION"
echo "========================================================"

cd ~/workspace/SYMPHONY_OF_CONNECTION

# Parar processos existentes
echo "🛑 Parando processos anteriores..."
./audio-fix-manager.sh stop
sleep 2

# Build do frontend com as melhorias
echo "🔨 Build do frontend aprimorado..."
cd frontend
npm run build

if [ $? -eq 0 ]; then
    echo "✅ Build das melhorias concluído"
    
    # Iniciar sistema completo
    echo "🚀 Iniciando sistema aprimorado..."
    cd ..
    ./audio-fix-manager.sh start
    
    echo ""
    echo "🎉 VERSÃO APRIMORADA IMPLANTADA!"
    echo "================================"
    echo ""
    echo "✨ NOVAS CARACTERÍSTICAS:"
    echo "   🌈 Partículas coloridas baseadas em emoções"
    echo "   🎯 Formações dinâmicas (esfera, explosão, enxame)"
    echo "   💫 Efeitos visuais extras e glow"
    echo "   🎨 Paleta de cores emocionais"
    echo "   ⚡ Comportamentos complexos de partículas"
    echo ""
    echo "🌐 ACESSE: http://localhost:3000"
    echo ""
    echo "💡 EXPERIMENTE:"
    echo "   - Movimentos suaves: cores calmas e formação esférica"
    echo "   - Movimentos rápidos: cores intensas e formação explosiva"
    echo "   - Observe as transições entre formações"
    echo "   - Veja as cores mudarem com suas emoções"
    
else
    echo "❌ Erro no build das melhorias"
    exit 1
fi
