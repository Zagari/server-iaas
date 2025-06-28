#!/bin/bash
set -e

# Atualiza pacotes
apt-get update && apt-get upgrade -y

# Instala pacotes básicos
apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    docker.io docker-compose git


# Adiciona chave GPG do Docker
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Adiciona repositório do Docker
echo \
  "deb [arch=arm64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

# Instala Docker Engine e Compose
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Adiciona usuário ubuntu ao grupo docker
usermod -aG docker ubuntu

# Habilita o Docker na inicialização
systemctl enable docker
systemctl start docker

# Cria diretório para containers
mkdir -p /home/ubuntu/containers
chown ubuntu:ubuntu /home/ubuntu/containers

