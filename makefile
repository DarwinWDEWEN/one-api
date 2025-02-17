# Makefile

PROJECT_NAME := one-api  # 项目名称，可以根据实际情况更改
GOOS :=linux             # 目标操作系统 (根据需要更改)
GOARCH :=amd64             # 目标架构 (根据需要更改)
BINARY_NAME := $(PROJECT_NAME) # 构建后的可执行文件名
VERSION := $(shell git describe --tags --always) # 从 Git 获取版本信息

# 设置构建输出目录
BUILD_DIR := build

# 设置 GOOS 和 GOARCH 环境变量
export GOOS
export GOARCH

# Go 工具
GO := go

# 构建目标
build:
	@echo "Building $(BINARY_NAME) for $(GOOS)/$(GOARCH)"
	mkdir -p $(BUILD_DIR)
	GOOS=$(GOOS) GOARCH=$(GOARCH) go build -ldflags "-s -w" -o $(BUILD_DIR)/$(shell echo $(BINARY_NAME)-$(GOOS)-$(GOARCH)  | tr -d ' ')
	@echo "Build complete!"

# 运行目标
run: build
	@echo "Running $(BUILD_DIR)/$(BINARY_NAME)"
	$(BUILD_DIR)/$(BINARY_NAME)

# 清理目标
clean:
	@echo "Cleaning build directory"
	rm -rf $(BUILD_DIR)

# 交叉编译目标
cross-build:
	@echo "Cross-compiling for all platforms"
	# 你可以添加更多平台，例如 windows/amd64, darwin/amd64, 等等
	GOOS=linux GOARCH=amd64 make build
	GOOS=darwin GOARCH=amd64 make build
	GOOS=windows GOARCH=amd64 make build

# 获取版本信息
appversion:
	@echo "Version: $(VERSION)"

# 默认目标 (如果直接运行 make，会执行 build)
.DEFAULT_GOAL := build

# 声明 PHONY 目标
.PHONY: build run clean cross-build appversion