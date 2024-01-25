# Define commands for backend
BACKEND_DIR := ./backend/cmd/server
FRONTEND_DIR := ./frontend
ZINC_DIR := ./zincsearch

.PHONY: run-backend
run-backend:
	cd $(BACKEND_DIR); go run main.go

.PHONY: build-backend
build-backend:
	cd $(BACKEND_DIR); go build

.PHONY: test-backend
test-backend:
	cd $(BACKEND_DIR); go test ./...

# Define commands for frontend
.PHONY: install-frontend
install-frontend:
	cd $(FRONTEND_DIR); npm install

.PHONY: run-frontend
run-frontend:
	cd $(FRONTEND_DIR); npm run serve

.PHONY: build-frontend
build-frontend:
	cd $(FRONTEND_DIR); npm run build

# Define commands for ZincSearch
.PHONY: run-zincsearch
run-zincsearch:
	cd $(ZINC_DIR); docker-compose up -d

.PHONY: setup-zincsearch
setup-zincsearch: setup-dataset; run-indexer

.PHONY: stop-zincsearch
stop-zincsearch:
	cd $(ZINC_DIR); docker-compose down

# All-in-one commands
.PHONY: run-all
run-all: run-zincsearch run-backend run-frontend

.PHONY: stop-all
stop-all: stop-zincsearch
	cd $(BACKEND_DIR); <your-command-to-stop-backend>
	cd $(FRONTEND_DIR); <your-command-to-stop-frontend>

.PHONY: setup-dataset
setup-dataset:
	./scripts/setup-enron-dataset.sh

.PHONY: run-indexer
run-indexer:
	cd backend/cmd/indexer; go run main.go

