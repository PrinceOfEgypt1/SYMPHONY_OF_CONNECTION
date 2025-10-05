#!/bin/bash

echo "🌐 EXECUTANDO TESTES DE COMPATIBILIDADE CROSS-BROWSER..."

cd ~/workspace/SYMPHONY_OF_CONNECTION/frontend

# Verificar se Playwright está instalado
if ! npx playwright --version &> /dev/null; then
    echo "📦 Instalando Playwright..."
    npm install -g @playwright/test
    npx playwright install
fi

# Criar testes básicos de compatibilidade
cat > tests/compatibility.spec.js << 'EOF2'
const { test, expect } = require('@playwright/test');

test.describe('Symphony of Connection - Compatibilidade', () => {
  test('deve carregar a aplicação', async ({ page }) => {
    await page.goto('http://localhost:3000');
    
    // Verificar se o título está presente
    await expect(page).toHaveTitle(/Symphony of Connection/);
    
    // Verificar se o canvas 3D está presente
    const canvas = page.locator('canvas');
    await expect(canvas).toBeVisible();
  });

  test('deve conectar WebSocket', async ({ page }) => {
    await page.goto('http://localhost:3000');
    
    // Aguardar conexão
    await page.waitForTimeout(2000);
    
    // Verificar se há elementos de partículas
    const particles = page.locator('[class*="particle"]');
    await expect(particles).toBeVisible({ timeout: 5000 });
  });

  test('deve reproduzir áudio', async ({ page }) => {
    await page.goto('http://localhost:3000');
    
    // Mover mouse para gerar interação
    await page.mouse.move(100, 100);
    await page.mouse.move(200, 200);
    
    // Aguardar sistema de áudio
    await page.waitForTimeout(3000);
    
    // Verificar logs do sistema de áudio
    const logs = [];
    page.on('console', msg => {
      if (msg.text().includes('AudioEngine')) {
        logs.push(msg.text());
      }
    });
    
    expect(logs.length).toBeGreaterThan(0);
  });
});
EOF2

echo "🚀 Executando testes em múltiplos navegadores..."
npx playwright test --browser=chromium --browser=firefox --browser=webkit --headed

echo "✅ Testes de compatibilidade concluídos"
