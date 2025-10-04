#!/bin/bash
echo "🏗️  Construindo versão de produção..."
cd ~/workspace/SYMPHONY_OF_CONNECTION/frontend
npm run build
echo "✅ Build completo! Arquivos em: frontend/dist/"
