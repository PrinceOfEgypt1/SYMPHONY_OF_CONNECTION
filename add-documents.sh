#!/bin/bash

echo "🎵 SYMPHONY OF CONNECTION - ADIÇÃO DE DOCUMENTOS"
echo "=================================================="

# Nomes exatos dos arquivos (mantenha a capitalização)
DOCUMENT1="ARQUITETURA TÉCNICA E PADRÕES DE DESENVOLVIMENTO"
DOCUMENT2="INSTRUÇÕES OBRIGATÓRIAS - SYMPHONY OF CONNECTION"
PROJECT_DIR="$HOME/workspace/SYMPHONY_OF_CONNECTION"

cd "$PROJECT_DIR" || exit 1

# Verificar se os arquivos já existem
check_documents() {
    if [ -f "$DOCUMENT1" ] && [ -f "$DOCUMENT2" ]; then
        echo "✅ Ambos os documentos encontrados!"
        return 0
    else
        echo ""
        echo "📋 **INSTRUÇÕES PARA CÓPIA MANUAL:**"
        echo "----------------------------------------"
        echo "1. Conecte o dispositivo com os arquivos (USB, HD, etc.)"
        echo "2. Copie os arquivos para este diretório:"
        echo "   📁 $PROJECT_DIR"
        echo ""
        echo "📄 Arquivos necessários:"
        echo "   • $DOCUMENT1"
        echo "   • $DOCUMENT2"
        echo ""
        echo "3. Você pode usar qualquer método:"
        echo "   • USB/HD externo"
        echo "   • Download da nuvem (Google Drive, etc.)"
        echo "   • Email para si mesmo"
        echo "   • SCP de outra máquina"
        echo ""
        echo "4. Após copiar, volte aqui e pressione ENTER"
        echo ""
        return 1
    fi
}

# Mostrar status atual
echo "🔍 Verificando documentos atuais..."
echo "----------------------------------------"
ls -la "$DOCUMENT1" 2>/dev/null || echo "❌ $DOCUMENT1 - AUSENTE"
ls -la "$DOCUMENT2" 2>/dev/null || echo "❌ $DOCUMENT2 - AUSENTE"
echo "----------------------------------------"

# Aguardar até que os arquivos estejam presentes
while ! check_documents; do
    echo "⏳ Aguardando cópia dos documentos..."
    echo "💡 Dica: Você pode abrir outro terminal para fazer a cópia"
    echo ""
    read -p "Pressione ENTER para verificar novamente (ou Ctrl+C para cancelar): "
    
    # Verificar novamente após pressionar ENTER
    echo ""
    echo "🔍 Verificando documentos..."
    echo "----------------------------------------"
    ls -la "$DOCUMENT1" 2>/dev/null || echo "❌ $DOCUMENT1 - AUSENTE"
    ls -la "$DOCUMENT2" 2>/dev/null || echo "❌ $DOCUMENT2 - AUSENTE"
    echo "----------------------------------------"
done

# Quando os arquivos estiverem presentes, adicionar ao Git
echo ""
echo "🚀 ADICIONANDO DOCUMENTOS AO GIT..."
echo "----------------------------------------"

# Verificar extensões dos arquivos e adicionar se necessário
add_extension_if_needed() {
    local file="$1"
    if [ -f "$file" ] && [[ ! "$file" =~ \..+$ ]]; then
        echo "📝 Arquivo '$file' sem extensão, adicionando .md"
        mv "$file" "$file.md"
        echo "$file.md"
    else
        echo "$file"
    fi
}

# Processar cada arquivo
DOCUMENT1=$(add_extension_if_needed "$DOCUMENT1")
DOCUMENT2=$(add_extension_if_needed "$DOCUMENT2")

# Adicionar ao Git
echo "📝 Adicionando ao Git..."
git add "$DOCUMENT1" "$DOCUMENT2"

echo "💾 Criando commit..."
git commit -m "docs: Adiciona documentação técnica completa

- ARQUITETURA TÉCNICA E PADRÕES DE DESENVOLVIMENTO
- INSTRUÇÕES OBRIGATÓRIAS - SYMPHONY OF CONNECTION

Documentação essencial para padronização do desenvolvimento do projeto."

echo "🚀 Enviando para GitHub..."
git push origin main

echo ""
echo "🎉 DOCUMENTOS ADICIONADOS COM SUCESSO!"
echo "=================================================="
echo "📚 Arquivos incluídos no repositório:"
echo "   • $DOCUMENT1"
echo "   • $DOCUMENT2"
echo ""
echo "🌐 GitHub: https://github.com/PrinceOfEgypt1/SYMPHONY_OF_CONNECTION"
echo ""
echo "✅ Processo concluído! Os documentos agora fazem parte do repositório."
