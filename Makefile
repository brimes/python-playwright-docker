# Makefile para Python Playwright Docker Base Image

# Variáveis
IMAGE_NAME = python-playwright-base
REGISTRY = ghcr.io/brimes/python-playwright-docker
TAG = latest

# Cores para output
GREEN = \033[0;32m
YELLOW = \033[1;33m
RED = \033[0;31m
NC = \033[0m # No Color

.PHONY: help build test clean push dev-setup lint size

# Target padrão
help: ## Mostrar esta ajuda
	@echo "$(GREEN)Comandos disponíveis:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-15s$(NC) %s\n", $$1, $$2}'

build: ## Construir a imagem Docker
	@echo "$(GREEN)🔧 Construindo imagem base...$(NC)"
	docker build -t $(IMAGE_NAME) .
	@echo "$(GREEN)✅ Imagem construída com sucesso!$(NC)"

test: build ## Construir e testar a imagem
	@echo "$(GREEN)🧪 Testando Playwright...$(NC)"
	@docker run --rm $(IMAGE_NAME) python -c "\
		from playwright.sync_api import sync_playwright; \
		print('✅ Playwright instalado com sucesso!'); \
		with sync_playwright() as p: \
			print('📦 Browser disponível:'); \
			print(f'  - Chromium: {len(p.chromium.executable_path) > 0}'); \
	"
	@echo "$(GREEN)📊 Informações da imagem:$(NC)"
	@docker run --rm $(IMAGE_NAME) python --version
	@docker run --rm $(IMAGE_NAME) python -c "import playwright; print(f'Playwright version: {playwright.__version__}')"

size: ## Mostrar tamanho da imagem
	@echo "$(GREEN)💾 Tamanho da imagem:$(NC)"
	@docker images $(IMAGE_NAME) --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"

clean: ## Limpar imagens e containers não utilizados
	@echo "$(YELLOW)🧹 Limpando imagens não utilizadas...$(NC)"
	docker image prune -f
	@echo "$(GREEN)✅ Limpeza concluída!$(NC)"

clean-all: ## Limpar TODAS as imagens e containers Docker
	@echo "$(RED)⚠️  Removendo TODAS as imagens e containers...$(NC)"
	@read -p "Tem certeza? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker system prune -af; \
		echo "$(GREEN)✅ Sistema Docker limpo!$(NC)"; \
	else \
		echo "$(YELLOW)Operação cancelada.$(NC)"; \
	fi

push: build test ## Fazer push da imagem para o registry
	@echo "$(GREEN)📤 Fazendo push para $(REGISTRY)...$(NC)"
	docker tag $(IMAGE_NAME) $(REGISTRY):$(TAG)
	docker push $(REGISTRY):$(TAG)
	@echo "$(GREEN)✅ Push concluído!$(NC)"

dev-setup: ## Configurar ambiente de desenvolvimento
	@echo "$(GREEN)🔧 Configurando ambiente de desenvolvimento...$(NC)"
	@if ! command -v docker &> /dev/null; then \
		echo "$(RED)❌ Docker não encontrado. Instale o Docker primeiro.$(NC)"; \
		exit 1; \
	fi
	@echo "$(GREEN)✅ Docker encontrado$(NC)"
	@echo "$(GREEN)✅ Ambiente configurado!$(NC)"

lint: ## Verificar Dockerfile com hadolint
	@echo "$(GREEN)🔍 Verificando Dockerfile...$(NC)"
	@if command -v hadolint &> /dev/null; then \
		hadolint Dockerfile; \
		echo "$(GREEN)✅ Dockerfile verificado!$(NC)"; \
	else \
		echo "$(YELLOW)⚠️  hadolint não encontrado. Instale com: brew install hadolint$(NC)"; \
	fi

run: build ## Executar container interativo para testes
	@echo "$(GREEN)🚀 Iniciando container interativo...$(NC)"
	docker run -it --rm $(IMAGE_NAME) /bin/bash

example: ## Mostrar exemplo de uso da imagem base
	@echo "$(GREEN)📝 Exemplo de Dockerfile usando a imagem base:$(NC)"
	@echo ""
	@cat Dockerfile.example
	@echo ""

version: ## Mostrar informações de versão
	@echo "$(GREEN)📋 Informações de versão:$(NC)"
	@cat version.json | python3 -m json.tool

stats: build ## Mostrar estatísticas detalhadas da imagem
	@echo "$(GREEN)📊 Estatísticas da imagem:$(NC)"
	@docker images $(IMAGE_NAME) --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}"
	@echo ""
	@echo "$(GREEN)📦 Layers da imagem:$(NC)"
	@docker history $(IMAGE_NAME) --no-trunc

all: clean build test size ## Executar pipeline completo (clean + build + test + size)