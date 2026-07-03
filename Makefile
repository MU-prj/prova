# Ambiente di sviluppo Roblox — vedi docs/SETUP.md per la guida completa.
#
# I tool si installano con Rokit (`rokit install`, consigliato sul tuo PC).
# Se un tool non è nel PATH si usa il fallback npm (`npm install` una volta).

ROJO   := $(shell command -v rojo   >/dev/null 2>&1 && echo rojo   || echo npx rojo)
STYLUA := $(shell command -v stylua >/dev/null 2>&1 && echo stylua || echo npx stylua)

BUILD_DIR := build
PLACE     := $(BUILD_DIR)/Prova.rbxlx

.PHONY: help setup build serve sourcemap fmt fmt-check lint check clean

help: ## Mostra questo aiuto
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'

setup: ## Installa i tool (Rokit se presente, altrimenti npm)
	@if command -v rokit >/dev/null 2>&1; then rokit install; else npm install; fi

build: ## Compila il place file Roblox (build/Prova.rbxlx)
	@mkdir -p $(BUILD_DIR)
	$(ROJO) build default.project.json -o $(PLACE)
	@echo "OK -> $(PLACE) (aprilo con Roblox Studio)"

serve: ## Avvia Rojo: collega VS Code a Roblox Studio in tempo reale
	$(ROJO) serve default.project.json

sourcemap: ## Rigenera la sourcemap per luau-lsp
	$(ROJO) sourcemap default.project.json -o sourcemap.json

fmt: ## Formatta tutto il codice Luau
	$(STYLUA) src

fmt-check: ## Verifica la formattazione senza modificare i file
	$(STYLUA) --check src

lint: ## Analisi statica con selene (richiede rokit install)
	@if command -v selene >/dev/null 2>&1; then selene src; \
	else echo "selene non installato: esegui 'rokit install' sul tuo PC"; fi

check: fmt-check lint ## Tutti i controlli di qualità

clean: ## Rimuove gli artefatti di build
	rm -rf $(BUILD_DIR) sourcemap.json
