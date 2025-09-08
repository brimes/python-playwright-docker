# Python Playwright Docker Base Image

Esta é uma imagem Docker base que contém Python 3.11 com Playwright e o br# Ou manualmente
docker run --rm ghcr.io/brimes/python-playwright-docker:latest python -c "from playwright.sync_api import sync_playwright; print('✅ Playwright funcionando!')"wser Chromium pré-instalado. Use esta imagem como base para seus projetos que utilizam Playwright, evitando o tempo de download e instalação do browser a cada build.

## 🚀 Uso Rápido

### Teste Local
```bash
# Clonar o repositório
git clone https://github.com/brimes/python-playwright-docker.git
cd python-playwright-docker

# Testar a imagem
make test
```

### Como usar esta imagem base

No seu projeto atual, substitua o Dockerfile por:

```dockerfile
# Use a imagem base com Playwright pré-instalado
FROM ghcr.io/brimes/python-playwright-docker:latest

# Definir diretório de trabalho
WORKDIR /app

# Copiar requirements e instalar dependências Python específicas do seu projeto
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar código da aplicação
COPY ./app ./app

# Expor porta
EXPOSE 8000

# Comando para iniciar a aplicação
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

## Tags Disponíveis

- `latest` - Versão mais recente
- `python3.11-playwright-chromium` - Python 3.11 com Playwright + Chromium
- `main` - Build da branch main
- `YYYY-MM-DD` - Builds datados

## 🔧 O que está incluído

- **Python 3.11-slim** como base
- **Playwright** com browser Chromium
- **Dependências do sistema** necessárias para execução do Chromium
- **Fontes** essenciais para renderização
- **Usuário não-root** (`appuser`) para segurança

## 🎯 Benefícios

- ⚡ **Builds mais rápidos** - Não precisa baixar o browser a cada build
- 💾 **Imagem menor** - Apenas Chromium (mais leve que Firefox + Webkit)
- 🔒 **Segurança** - Usuário não-root pré-configurado
- 📦 **Otimizado** - Apenas dependências necessárias para Chromium
- 🔄 **Atualizado** - Builds automáticos semanais

## 🏗️ Desenvolvimento Local

### Usando o Makefile

Este projeto inclui um Makefile para facilitar o desenvolvimento e testes:

```bash
# Mostrar todos os comandos disponíveis
make help

# Construir e testar a imagem
make test

# Apenas construir a imagem
make build

# Ver o tamanho da imagem
make size

# Executar pipeline completo (limpar + construir + testar + tamanho)
make all

# Limpar imagens não utilizadas
make clean

# Container interativo para testes
make run

# Mostrar exemplo de uso
make example
```

### Build Manual

Para fazer build manual da imagem:

```bash
docker build -t python-playwright-base .
```

## 🧪 Teste

### Teste Rápido
```bash
# Usando o Makefile (recomendado)
make test

# Ou manualmente
```bash
docker run --rm ghcr.io/brimes/python-playwright-docker:latest python -c "from playwright.sync_api import sync_playwright; print('✅ Playwright funcionando!')"
```
```

### Testes Avançados
```bash
# Container interativo para testes
make run

# Ver estatísticas da imagem
make stats

# Verificar Dockerfile (requer hadolint)
make lint
```

## 📋 Exemplo Completo

Veja um exemplo de como migrar seu Dockerfile atual:

### Antes (Dockerfile original)
```dockerfile
FROM python:3.11-slim
# ... várias linhas instalando playwright e dependências ...
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY ./app ./app
# ... resto da configuração ...
```

### Depois (usando a imagem base)
```dockerfile
FROM ghcr.io/brimes/python-playwright-docker:latest
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY ./app ./app
# ... resto da configuração ...
```

## �️ Comandos Úteis

| Comando | Descrição |
|---------|-----------|
| `make help` | Mostrar todos os comandos disponíveis |
| `make test` | Construir e testar a imagem |
| `make build` | Apenas construir a imagem |
| `make size` | Mostrar tamanho da imagem |
| `make clean` | Limpar imagens não utilizadas |
| `make run` | Container interativo para testes |
| `make example` | Mostrar exemplo de Dockerfile |
| `make all` | Pipeline completo (clean + build + test + size) |

## �🔄 Atualizações

A imagem é automaticamente reconstruída:
- Quando há mudanças no Dockerfile
- Semanalmente (toda segunda-feira)
- Pode ser executada manualmente via GitHub Actions

## 🆘 Suporte

Para problemas ou sugestões, abra uma issue no repositório.