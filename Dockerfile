# Dockerfile base para Python com Playwright
# Esta imagem serve como base para projetos que utilizam Playwright
FROM python:3.11-slim

# Metadata da imagem
LABEL maintainer="brimes"
LABEL description="Python 3.11 with Playwright Chromium browser pre-installed"
LABEL version="1.0.2"

# Variáveis de ambiente
ENV PYTHONUNBUFFERED=1
ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright
ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependências do sistema necessárias para o Playwright
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    gnupg \
    ca-certificates \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Atualizar pip
RUN pip install --upgrade pip

# Instalar Playwright
RUN pip install --no-cache-dir playwright==1.40.0

# Instalar apenas o browser Chromium
RUN playwright install chromium

# Instalar dependências essenciais para Chromium (incluindo ARM64)
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Dependências essenciais para Chromium
    libnss3 \
    libnspr4 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libdrm2 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libgbm1 \
    libxss1 \
    libasound2 \
    # Dependências adicionais críticas para ARM64
    libgtk-3-0 \
    libgdk-pixbuf-2.0-0 \
    libxfixes3 \
    libxi6 \
    libxrender1 \
    libxext6 \
    libx11-6 \
    libxcb1 \
    libxcursor1 \
    libxtst6 \
    libxkbfile1 \
    libxinerama1 \
    # OpenGL essencial
    libgl1-mesa-dri \
    # Fontes essenciais
    fonts-liberation \
    fonts-unifont \
    fonts-noto-color-emoji \
    fonts-dejavu-core \
    # Limpeza final
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Criar diretório de trabalho padrão
WORKDIR /app

# Verificar instalação do Playwright
RUN python -c "from playwright.sync_api import sync_playwright; print('Playwright instalado com sucesso!')"

# Comando padrão (pode ser sobrescrito)
CMD ["python", "--version"]