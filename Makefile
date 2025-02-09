SHELL := /bin/bash

# Configurações do nvm
NVM_DIR := $(HOME)/.nvm
NVM_EXEC := $(NVM_DIR)/nvm.sh

# Inicializa o nvm e o ambiente
NVM_ENV := . $(NVM_EXEC) &&

# Verifica se o nvm está instalado
ifeq (,$(wildcard $(NVM_EXEC)))
$(error "NVM não encontrado no diretório $(NVM_DIR). Por favor, instale o nvm.")
endif

.PHONY: env dev lint build check

install:
	@$(NVM_ENV) nvm use v20* && \
		npm install

dev:
	@$(NVM_ENV) nvm use v20* && \
		npm run dev

lint:
	@npm run lint

build:
	@npm run build

docker-up:
	docker buildx build -f Dockerfile -t 3btc/authon-api:0.0.2 . ; \
	docker run -d --name authon-api.c1 --env-file=.env.docker --network=kong-net --add-host host.docker.internal:host-gateway --restart=unless-stopped 3btc/authon-api:0.0.2; \
	docker run -d --name authon-api.c2 --env-file=.env.docker --network=kong-net --add-host host.docker.internal:host-gateway --restart=unless-stopped 3btc/authon-api:0.0.2;

docker-down:
	docker container kill authon-api.c1; docker container rm authon-api.c1; \
	docker container kill authon-api.c2; docker container rm authon-api.c2; \
	docker image rm 3btc/authon-api:0.0.2
