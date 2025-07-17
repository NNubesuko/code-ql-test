FROM mcr.microsoft.com/devcontainers/dotnet:9.0

WORKDIR /workspaces

# 必要なパッケージのインストール
RUN apt-get update && \
    apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Dockerの公式GPG鍵を追加
RUN mkdir -m 0755 -p /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Dockerリポジトリを追加
RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Docker CLI をインストール
RUN apt-get update && \
    apt-get install -y docker-ce-cli