#!/bin/bash

# Caminhos comuns onde malwares podem se esconder
ALVOS=(
    /etc
    /opt
    /usr/bin
    /usr/lib
    /usr/local/bin
    /usr/local/lib
    /home
    /tmp
    /var/tmp
    /root
)

# Converte array em string
CAMINHOS=$(printf " %s" "${ALVOS[@]}")

# Caminho do log
LOG="/var/log/clamav/verificacao_rapida.log"

# Verifica se ClamAV está instalado
if ! command -v clamscan &> /dev/null; then
    echo "❌ ClamAV não está instalado. Instale com: sudo apt install clamav"
    exit 1
fi

# Atualiza base de dados
echo "🔄 Atualizando base de dados do ClamAV..."
sudo freshclam

# Cria pasta do log se necessário
sudo mkdir -p "$(dirname "$LOG")"

# Inicia verificação
echo "🛡️ Iniciando verificação nas pastas críticas..."
sudo clamscan -i -r $CAMINHOS | tee "$LOG"

echo "✅ Verificação concluída. Resultados salvos em: $LOG"

