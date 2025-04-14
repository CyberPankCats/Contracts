# Makefile for Protocol Buffers code generation

PROTO_DIR=proto
GEN_DIR=gen
PROTO_FILES=$(shell find $(PROTO_DIR) -name '*.proto')

# Go settings
GO_OUT=$(GEN_DIR)/go
GO_OPTS=paths=source_relative

# Python settings
PYTHON_OUT=$(GEN_DIR)/python

# JavaScript settings
JS_OUT=$(GEN_DIR)/js
JS_OPTS=import_style=commonjs,binary

# Java settings
JAVA_OUT=$(GEN_DIR)/java

# gRPC settings
GRPC_OPTS=paths=source_relative

# Отключаем встроенные правила
.SUFFIXES:

# Объявляем все цели как phony
.PHONY: all clean install-tools gen-go gen-python gen-js gen-java

all: gen-go gen-python gen-js gen-java


gen-go:
	@echo "Generating Go code..."
	mkdir -p $(GO_OUT)
	protoc -I=$(PROTO_DIR) \
		--go_out=$(GO_OUT) \
		--go_opt=$(GO_OPTS) \
		--go-grpc_out=$(GO_OUT) \
		--go-grpc_opt=$(GRPC_OPTS) \
		$(PROTO_FILES)

gen-python:
	@echo "Generating Python code..."
	mkdir -p $(PYTHON_OUT)
	protoc -I=$(PROTO_DIR) \
		--python_out=$(PYTHON_OUT) \
		--grpc_python_out=$(PYTHON_OUT) \
		--mypy_out=$(PYTHON_OUT) \
		$(PROTO_FILES)

gen-js:
	@echo "Generating JavaScript code..."
	mkdir -p $(JS_OUT)
	protoc -I=$(PROTO_DIR) \
		--js_out=$(JS_OPTS):$(JS_OUT) \
		--grpc-web_out=import_style=commonjs,mode=grpcwebtext:$(JS_OUT) \
		$(PROTO_FILES)

gen-java:
	@echo "Generating Java code..."
	mkdir -p $(JAVA_OUT)
	protoc -I=$(PROTO_DIR) \
		--java_out=$(JAVA_OUT) \
		--grpc-java_out=$(JAVA_OUT) \
		$(PROTO_FILES)

clean:
	@echo "Cleaning generated files..."
	@rm -rf $(GEN_DIR)

install-tools:
	@echo "Installing required tools..."
	go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
	pip install grpcio-tools mypy-protobuf
	npm install -g grpc-tools grpc-web