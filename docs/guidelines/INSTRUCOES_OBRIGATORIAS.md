# 📋 INSTRUÇÕES OBRIGATÓRIAS - SYMPHONY OF CONNECTION

## PROTOCOLO DE DESENVOLVIMENTO COM GITHUB COMO FONTE DA VERDADE

---

## VISÃO E PROPÓSITO

Criar uma experiência digital emocionalmente cativante onde múltiplos usuários se conectam em tempo real através de expressões emocionais traduzidas em arte generativa visual e sonora. Uma sinfonia humana-digital que transcende a comunicação verbal.

---

## REGRAS FUNDAMENTAIS

### REGRA #1: GITHUB COMO FONTE ÚNICA

- **OBRIGATÓRIO:** Consultar o repositório GitHub antes de qualquer desenvolvimento
- **OBRIGATÓRIO:** Sincronizar código local com `git pull origin main` antes de iniciar trabalho
- **PROIBIDO:** Desenvolver sem verificar o estado atual no GitHub

### REGRA #2: CICLO DE SPRINTS CONTROLADO

- **OBRIGATÓRIO:** Commits apenas ao final de cada sprint concluída e testada
- **OBRIGATÓRIO:** Cada sprint deve ter objetivo claro e entregável testável
- **PROIBIDO:** Commits parciais ou de código não testado

### REGRA #3: VALIDAÇÃO ANTI-REGRESSÃO

- **OBRIGATÓRIO:** Validação completa antes de qualquer push para GitHub
- **OBRIGATÓRIO:** Build deve passar sem erros (`npm run build`)
- **OBRIGATÓRIO:** Serviços devem iniciar corretamente (`npm run dev`)
- **PROIBIDO:** Push de código que quebra funcionalidades existentes

### REGRA #4: EVOLUÇÃO INCREMENTAL

- **OBRIGATÓRIO:** Uma funcionalidade por sprint
- **OBRIGATÓRIO:** Preservar funcionalidades existentes
- **PROIBIDO:** Reescrever componentes inteiros sem justificativa técnica
- **PROIBIDO:** Implementar múltiplas funcionalidades simultaneamente

### REGRA #5: EXPERIÊNCIA PRIMEIRO

- **OBRIGATÓRIO:** Manter a magia visual e emocional da experiência
- **OBRIGATÓRIO:** Performance mínima de 45 FPS
- **OBRIGATÓRIO:** Interface visualmente impressionante e responsiva

---

## PROTOCOLO DE SPRINT

### PRÉ-SPRINT: PREPARAÇÃO

1. Consultar estado atual no GitHub
2. Sincronizar código local: `git pull origin main`
3. Validar build e serviços funcionando
4. Definir escopo claro da sprint (1 funcionalidade principal)

### DURANTE SPRINT: DESENVOLVIMENTO

1. Desenvolver funcionalidade definida
2. Testar continuamente a experiência do usuário
3. Manter funcionalidades existentes operacionais
4. Documentar código com JSDoc/TSDoc

### PÓS-SPRINT: VALIDAÇÃO E ENTREGA

1. Executar validação anti-regressão completa
2. Testar experiência do usuário final
3. Verificar performance e estabilidade
4. Commit único com descrição clara da sprint
5. Push para GitHub apenas se TODOS os testes passarem

---

## CRITÉRIOS DE ACEITAÇÃO

- ✅ Código compila sem erros
- ✅ Frontend (localhost:3000) funciona perfeitamente
- ✅ Backend (localhost:5000) responde corretamente
- ✅ WebSockets e colaboração em tempo real operacionais
- ✅ Experiência visual mantém impacto emocional
- ✅ Performance mínima de 45 FPS atingida
- ✅ Zero regressões introduzidas
- ✅ Documentação atualizada

---

## VALIDAÇÃO ANTI-REGRESSÃO

### Checklist Obrigatório Antes de Push:

```bash
# 1. Build deve passar
npm run build

# 2. Serviços devem iniciar
npm run dev

# 3. Frontend deve estar acessível
curl http://localhost:3000

# 4. Backend deve responder
curl http://localhost:5000/health
```

**Se QUALQUER teste falhar → NÃO FAZER PUSH**

---

## ESTRUTURA DE COMMITS

### Formato Obrigatório:

```
tipo(escopo): descrição clara da sprint

- Detalhe 1 do que foi implementado
- Detalhe 2 do que foi testado
- Detalhe 3 das validações realizadas
```

### Tipos Válidos:
- `feat`: Nova funcionalidade
- `fix`: Correção de bug
- `perf`: Melhoria de performance
- `docs`: Documentação
- `refactor`: Refatoração de código
- `test`: Adição de testes
- `chore`: Tarefas de manutenção

### Exemplo:
```
feat(realtime): Implementar sincronização de estado emocional via WebSockets

- Sistema de broadcasting de estado emocional
- Sincronização automática entre clientes
- Reconexão automática em caso de falha
- Validação anti-regressão: 100% passed
- Performance: 60 FPS mantido
```

---

## FLUXO DE TRABALHO COMPLETO

### 1. Início do Trabalho
```bash
cd ~/workspace/SYMPHONY_OF_CONNECTION
git pull origin main
git status
npm run build  # Validar que está tudo funcionando
```

### 2. Durante o Desenvolvimento
```bash
# Testar continuamente
npm run dev

# Validar no navegador
# Frontend: http://localhost:3000
# Backend: http://localhost:5000
```

### 3. Antes do Commit
```bash
# Validação completa
npm run build
npm run dev

# Verificar que tudo funciona
# Frontend + Backend + WebSockets
```

### 4. Commit e Push
```bash
git add .
git commit -m "feat(escopo): descrição clara"
git push origin main
```

---

## COMPROMISSO DE QUALIDADE

> "Entregaremos incrementalmente uma experiência que genuinamente conecte pessoas através da emoção e arte generativa. Cada sprint avança concretamente em direção a esta visão, mantendo sempre uma base estável e funcional."

---

## STACK TÉCNICO DEFINIDO

### Frontend
- React 18+
- TypeScript (strict mode)
- Three.js + React Three Fiber
- Zustand (gerenciamento de estado)
- Tone.js (áudio generativo)
- Vite (build tool)

### Backend
- Node.js 18+
- TypeScript (strict mode)
- Socket.io (WebSockets)
- Express (API REST)

### DevOps
- Git + GitHub
- npm workspaces (monorepo)
- ESLint + Prettier
- Jest (testes)

---

## METAS DE QUALIDADE

| Métrica | Meta | Medição |
|---------|------|---------|
| Performance | ≥ 45 FPS | React DevTools |
| Carregamento | < 3s | Lighthouse |
| Latência Audio-Visual | < 50ms | Manual |
| Estabilidade Build | 100% | CI/CD |
| Zero Regressões | 100% | Testes manuais |

---

## PROIBIÇÕES ABSOLUTAS

❌ **NUNCA:**
- Fazer push de código que não compila
- Fazer push de código que quebra funcionalidades
- Criar arquivos .bak, .backup, .save
- Desenvolver sem sincronizar com GitHub primeiro
- Commitar código não testado
- Implementar múltiplas funcionalidades em uma sprint

✅ **SEMPRE:**
- Consultar GitHub antes de começar
- Sincronizar com `git pull origin main`
- Validar build e runtime antes de push
- Testar experiência do usuário
- Manter performance acima de 45 FPS
- Documentar código adequadamente

---

**Versão:** 1.0  
**Última Atualização:** $(date +%d/%m/%Y)  
**Status:** Ativo  
**Repositório:** https://github.com/PrinceOfEgypt1/SYMPHONY_OF_CONNECTION
