#!/bin/bash

echo "🔄 TRANSFERINDO DOCUMENTOS DO WINDOWS PARA O REPOSITÓRIO"

# Diretório de origem no Windows (via montagem SMB ou via SSH)
WINDOWS_SOURCE="/mnt/windows/Users/Projetos/SYMPHONY_OF_CONNECTION"
LOCAL_PROJECT_DIR="$HOME/workspace/SYMPHONY_OF_CONNECTION"

# Nomes dos arquivos que precisam ser transferidos
DOCUMENT1="ARQUITETURA TÉCNICA E PADRÕES DE DESENVOLVIMENTO"
DOCUMENT2="INSTRUÇÕES OBRIGATÓRIAS - SYMPHONY OF CONNECTION"

# Verificar se o diretório do Windows está montado
check_windows_access() {
    echo "🔍 Verificando acesso aos arquivos do Windows..."
    
    # Método 1: Verificar se está montado via SMB
    if [ -d "$WINDOWS_SOURCE" ]; then
        echo "✅ Diretório do Windows detectado via montagem SMB"
        return 0
    fi
    
    # Método 2: Tentar acessar via caminho alternativo
    ALTERNATE_PATH="/media/moises/windows/Users/Projetos/SYMPHONY_OF_CONNECTION"
    if [ -d "$ALTERNATE_PATH" ]; then
        WINDOWS_SOURCE="$ALTERNATE_PATH"
        echo "✅ Diretório do Windows detectado em localização alternativa"
        return 0
    fi
    
    # Método 3: Verificar se os arquivos já foram copiados anteriormente
    if [ -f "$LOCAL_PROJECT_DIR/$DOCUMENT1" ] && [ -f "$LOCAL_PROJECT_DIR/$DOCUMENT2" ]; then
        echo "✅ Documentos já existem no projeto local"
        return 0
    fi
    
    echo "❌ Não foi possível acessar os arquivos do Windows automaticamente"
    return 1
}

# Copiar documentos do Windows para o repositório local
copy_documents() {
    echo "📁 Copiando documentos do Windows para o repositório..."
    
    # Verificar se os arquivos existem no Windows
    if [ ! -f "$WINDOWS_SOURCE/$DOCUMENT1" ]; then
        echo "❌ Arquivo '$DOCUMENT1' não encontrado em: $WINDOWS_SOURCE"
        return 1
    fi
    
    if [ ! -f "$WINDOWS_SOURCE/$DOCUMENT2" ]; then
        echo "❌ Arquivo '$DOCUMENT2' não encontrado em: $WINDOWS_SOURCE"
        return 1
    fi
    
    # Copiar arquivos
    cp "$WINDOWS_SOURCE/$DOCUMENT1" "$LOCAL_PROJECT_DIR/"
    cp "$WINDOWS_SOURCE/$DOCUMENT2" "$LOCAL_PROJECT_DIR/"
    
    # Verificar se a cópia foi bem-sucedida
    if [ -f "$LOCAL_PROJECT_DIR/$DOCUMENT1" ] && [ -f "$LOCAL_PROJECT_DIR/$DOCUMENT2" ]; then
        echo "✅ Documentos copiados com sucesso!"
        return 0
    else
        echo "❌ Erro ao copiar documentos"
        return 1
    fi
}

# Método alternativo via SCP (se o Windows estiver acessível via rede)
transfer_via_scp() {
    echo "🌐 Tentando transferência via SCP..."
    
    # Substitua pelos valores corretos
    WINDOWS_USER="SeuUsuarioWindows"
    WINDOWS_IP="192.168.1.100"  # IP do Windows
    WINDOWS_PATH="C:/Users/Projetos/SYMPHONY_OF_CONNECTION"
    
    echo "📤 Transferindo '$DOCUMENT1'..."
    scp "$WINDOWS_USER@$WINDOWS_IP:\"$WINDOWS_PATH/$DOCUMENT1\"" "$LOCAL_PROJECT_DIR/" || {
        echo "❌ Falha na transferência SCP do primeiro documento"
        return 1
    }
    
    echo "📤 Transferindo '$DOCUMENT2'..."
    scp "$WINDOWS_USER@$WINDOWS_IP:\"$WINDOWS_PATH/$DOCUMENT2\"" "$LOCAL_PROJECT_DIR/" || {
        echo "❌ Falha na transferência SCP do segundo documento"
        return 1
    }
    
    echo "✅ Transferência SCP concluída!"
    return 0
}

# Adicionar documentos ao Git
add_to_git() {
    echo "📝 Adicionando documentos ao Git..."
    
    cd "$LOCAL_PROJECT_DIR" || exit 1
    
    # Verificar se os arquivos existem localmente
    if [ ! -f "$DOCUMENT1" ] || [ ! -f "$DOCUMENT2" ]; then
        echo "❌ Documentos não encontrados no diretório do projeto"
        return 1
    fi
    
    # Adicionar ao Git
    git add "$DOCUMENT1" "$DOCUMENT2"
    
    # Fazer commit
    git commit -m "docs: Adiciona documentação de arquitetura e instruções obrigatórias
    
    - ARQUITETURA TÉCNICA E PADRÕES DE DESENVOLVIMENTO
    - INSTRUÇÕES OBRIGATÓRIAS - SYMPHONY OF CONNECTION"
    
    # Fazer push
    git push origin main
    
    echo "✅ Documentos adicionados ao repositório GitHub!"
}

# Fluxo principal
main() {
    echo "🚀 INICIANDO TRANSFERÊNCIA DE DOCUMENTOS"
    echo "=========================================="
    
    # Tentar método de montagem direta primeiro
    if check_windows_access && copy_documents; then
        echo "✅ Transferência via montagem direta bem-sucedida"
    else
        echo "🔄 Tentando método alternativo..."
        echo "💡 Dica: Certifique-se de que:"
        echo "  1. O Windows está acessível na rede"
        echo "  2. O compartilhamento SMB está ativo" 
        echo "  3. Ou os arquivos estão em /media/ ou /mnt/"
        echo ""
        echo "📋 Soluções manuais:"
        echo "  Opção 1: Monte manualmente: sudo mount -t cifs //IP_WINDOWS/Users /mnt/windows -o username=usuario,password=senha"
        echo "  Opção 2: Copie via USB/HD externo"
        echo "  Opção 3: Use SCP conforme configurado no script"
        
        # Perguntar se deseja tentar SCP
        read -p "Tentar transferência via SCP? (s/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Ss]$ ]]; then
            transfer_via_scp || {
                echo "❌ Todos os métodos automáticos falharam."
                echo "📋 Por favor, copie os arquivos manualmente para: $LOCAL_PROJECT_DIR"
                exit 1
            }
        else
            echo "📋 Por favor, copie os arquivos manualmente para: $LOCAL_PROJECT_DIR"
            exit 1
        fi
    fi
    
    # Adicionar ao Git
    add_to_git
    
    echo ""
    echo "🎉 TRANSFERÊNCIA CONCLUÍDA COM SUCESSO!"
    echo "📚 Documentos incluídos no repositório GitHub"
}

# Executar fluxo principal
main
