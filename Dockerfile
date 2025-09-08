# Dockerfile base para Python com Playwright
# Esta imagem serve como base para projetos que utilizam Playwright
FROM python:3.11-slim

# Metadata da imagem
LABEL maintainer="brimes"
LABEL description="Python 3.11 with Playwright Chromium browser pre-installed"
LABEL version="1.0.0"

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

# Instalar dependências essenciais para Chromium
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Dependências para Chromium
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
    # Fontes essenciais
    fonts-liberation \
    fonts-unifont \
    fonts-noto-color-emoji \
    && rm -rf /var/lib/apt/lists/*

# Criar diretório de trabalho padrão
WORKDIR /app

# Criar usuário não-root para segurança
RUN adduser --disabled-password --gecos '' appuser && \
    chown -R appuser:appuser /app && \
    chown -R appuser:appuser /ms-playwright

# Verificar instalação do Playwright
RUN su appuser -c "python -c 'from playwright.sync_api import sync_playwright; print(\"Playwright instalado com sucesso!\")'"

# Mudar para usuário não-root
USER appuser

# Comando padrão (pode ser sobrescrito)
CMD ["python", "--version"]