.PHONY: all clean init config build run rebuild help info view

BUILD_DIR      := build
BUILD_TYPE     ?= Release
CONAN_BUILD_DIR:= $(BUILD_DIR)/build/$(BUILD_TYPE)
GENERATORS_DIR := $(CONAN_BUILD_DIR)/generators
EXECUTABLE     := $(CONAN_BUILD_DIR)/bin/kplot_demo
SVG            := out.svg

GREEN  := \033[0;32m
YELLOW := \033[0;33m
BLUE   := \033[0;34m
CYAN   := \033[0;36m
NC     := \033[0m

all: init config build

help:
	@echo "$(CYAN)╔════════════════════════════════════════════╗$(NC)"
	@echo "$(CYAN)║        KPlot Demo - Build System         ║$(NC)"
	@echo "$(CYAN)╚════════════════════════════════════════════╝$(NC)"
	@echo ""
	@echo "$(BLUE)📦 Comandos disponíveis:$(NC)"
	@echo "  $(GREEN)make all$(NC)       - Executa init, config e build"
	@echo "  $(GREEN)make init$(NC)      - Instala dependências com Conan"
	@echo "  $(GREEN)make config$(NC)    - Configura o projeto com CMake"
	@echo "  $(GREEN)make build$(NC)     - Compila o projeto"
	@echo "  $(GREEN)make run$(NC)       - Gera o gráfico out.svg"
	@echo "  $(GREEN)make view$(NC)      - Abre o SVG (se xdg-open)"
	@echo "  $(GREEN)make rebuild$(NC)   - Limpa e reconstrói tudo"
	@echo "  $(GREEN)make clean$(NC)     - Remove arquivos de build"
	@echo "  $(GREEN)make info$(NC)      - Informações do projeto"
	@echo ""
	@echo "$(YELLOW)⚙️  Variáveis:$(NC)"
	@echo "  BUILD_TYPE=Release|Debug (padrão: Release)"
	@echo ""
	@echo "$(CYAN)🚀 Exemplos de uso:$(NC)"
	@echo "  make all && make run && make view"

init:
	@echo "$(BLUE)>>> 📦 Instalando KPlot com Conan...$(NC)"
	conan install . --output-folder=$(BUILD_DIR) --build=missing \
		-s build_type=$(BUILD_TYPE)
	@echo "$(GREEN)✓ Dependências instaladas$(NC)"

config:
	@if [ ! -f "$(GENERATORS_DIR)/conan_toolchain.cmake" ]; then \
		echo "$(YELLOW)⚠  Toolchain do Conan não encontrado. Execute 'make init' primeiro.$(NC)"; \
		exit 1; \
	fi
	@echo "$(BLUE)>>> ⚙️  Configurando CMake...$(NC)"
	cmake -S . -B $(CONAN_BUILD_DIR) \
		-DCMAKE_TOOLCHAIN_FILE=$(GENERATORS_DIR)/conan_toolchain.cmake \
		-DCMAKE_BUILD_TYPE=$(BUILD_TYPE)
	@echo "$(GREEN)✓ CMake configurado$(NC)"

build:
	@if [ ! -f "$(CONAN_BUILD_DIR)/Makefile" ] && [ ! -f "$(CONAN_BUILD_DIR)/build.ninja" ]; then \
		echo "$(YELLOW)⚠  Arquivos de build não encontrados. Execute 'make config' primeiro.$(NC)"; \
		exit 1; \
	fi
	@echo "$(BLUE)>>> 🔨 Compilando projeto...$(NC)"
	cmake --build $(CONAN_BUILD_DIR) --config $(BUILD_TYPE) -j $$(nproc)
	@echo "$(GREEN)✓ Compilação concluída$(NC)"
	@echo "$(YELLOW)ℹ  Executável: $(EXECUTABLE)$(NC)"

run:
	@if [ ! -f "$(EXECUTABLE)" ]; then \
		echo "$(YELLOW)⚠  Executável não encontrado. Execute 'make build' primeiro.$(NC)"; \
		exit 1; \
	fi
	@echo "$(CYAN)>>> 📊 Gerando gráfico out.svg$(NC)"
	$(EXECUTABLE)
	@echo "$(GREEN)✓ SVG salvo em $(SVG)$(NC)"

view:
	@if [ -f "$(SVG)" ]; then \
		echo "$(CYAN)>>> 📈 Abrindo $(SVG)$(NC)"; \
		xdg-open $(SVG) || echo "$(YELLOW)xdg-open falhou – abra $(SVG) manualmente$(NC)"; \
	else \
		echo "$(YELLOW)⚠  $(SVG) não encontrado. Execute 'make run' primeiro.$(NC)"; \
	fi

rebuild: clean all

clean:
	@echo "$(YELLOW)>>> 🧹 Limpando arquivos de build...$(NC)"
	rm -rf $(BUILD_DIR) $(SVG)
	@echo "$(GREEN)✓ Limpeza concluída$(NC)"

info:
	@echo "$(CYAN)>>> Informações do projeto$(NC)"
	@echo "Build Type : $(BUILD_TYPE)"
	@echo "Build Dir  : $(CONAN_BUILD_DIR)"
	@echo "Executable : $(EXECUTABLE)"
	@if [ -f "$(EXECUTABLE)" ]; then ls -lh $(EXECUTABLE); fi

