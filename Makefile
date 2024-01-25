# Define variables
AWS_REGION := us-west-2
ECR_REPOSITORY := your-ecr-repository-name
IMAGE_TAG := latest
IMAGE_NAME := go-api-image
# Define commands for backend
BACKEND_DIR := ./backend/cmd/server
FRONTEND_DIR := ./frontend
ZINC_DIR := ./zincsearch

# AWS ECR URL (replace with your actual ECR URL)
ECR_URL := $(shell aws ecr describe-repositories --repository-names $(ECR_REPOSITORY) --region $(AWS_REGION) --query 'repositories[0].repositoryUri' --output text)

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

.PHONY: build-image
build-image:
	docker build -t $(IMAGE_NAME) .

.PHONY: ecr-login
ecr-login:
	aws ecr get-login-password --region $(AWS_REGION) | docker login --username AWS --password-stdin $(ECR_URL)

.PHONY: tag-image
tag-image:
	docker tag $(IMAGE_NAME):$(IMAGE_TAG) $(ECR_URL):$(IMAGE_TAG)

.PHONY: push-image
push-image:
	docker push $(ECR_URL):$(IMAGE_TAG)

# Combined command to build and push the image
.PHONY: deploy-image
deploy-image: build-image ecr-login tag-image push-image