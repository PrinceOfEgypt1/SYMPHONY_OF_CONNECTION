#!/bin/bash

echo "🧪 EXECUTANDO TESTE DE CARGA NO BACKEND..."

cd ~/workspace/SYMPHONY_OF_CONNECTION/backend

# Verificar se artillery está instalado
if ! command -v artillery &> /dev/null; then
    echo "📦 Instalando Artillery..."
    npm install -g artillery
fi

# Criar configuração de teste de carga
cat > load-test.yml << 'EOF2'
config:
  target: "http://localhost:5000"
  phases:
    - duration: 60
      arrivalRate: 5
      name: "Fase de aquecimento"
    - duration: 120
      arrivalRate: 20
      name: "Fase de carga"
  scenarios:
    - name: "Health Check"
      flow:
        - get:
            url: "/health"
    - name: "Conexão de Usuário"
      flow:
        - post:
            url: "/api/users"
            json:
              name: "Test User"
            capture:
              json: "$.userId"
              as: "userId"
        - think: 2
        - get:
            url: "/api/users/{{ userId }}"
EOF2

echo "🚀 Iniciando teste de carga..."
artillery run load-test.yml --output load-test-report.json

echo "📊 Gerando relatório..."
artillery report load-test-report.json

echo "✅ Teste de carga concluído"
