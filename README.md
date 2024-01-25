# Enron Email Dataset Search Service

## Overview

This service allows users to index and search through the Enron Email Dataset using a Go backend, a Vue.js frontend, and ZincSearch for full-text search capabilities. 

## Prerequisites

- Go (version 1.x)
- Node.js and npm
- Docker and Docker Compose
- Access to the Enron Email Dataset

## Project Structure

- `backend/`: Contains Go code for the backend server and email indexer.
- `frontend/`: Contains Vue.js code for the frontend application.
- `zincsearch/`: Contains Docker Compose file to set up ZincSearch.
- `scripts/`: Contains utility scripts, including for dataset setup.

## Setup

### ZincSearch Setup

Navigate to the `zincsearch` directory and start ZincSearch:

```bash
cd zincsearch
docker-compose up -d
```

### Backend Setup

Navigate to the `backend` directory, install Go dependencies and run the backend server:

```bash
cd backend
go mod tidy
go run main.go
```

### Frontend Setup

Navigate to the `frontend` directory, install npm packages, and run the Vue.js application:

```bash
cd frontend
npm install
npm run serve
```

### Dataset Setup

Run the script to download and set up the Enron Email Dataset:

```bash
./scripts/setup-enron-dataset.sh
```

### Indexer Run

Navigate to the indexer directory and run the indexer to process and index the emails:

```bash
cd backend/cmd/indexer
go run main.go
```

## Makefile Commands

The provided Makefile simplifies the process of building and running different parts of the application:

- `make run-backend`: Runs the Go backend server.
- `make build-backend`: Builds the Go backend server.
- `make test-backend`: Runs tests for the Go backend.
- `make install-frontend`: Installs dependencies for the Vue.js frontend.
- `make run-frontend`: Runs the Vue.js frontend application.
- `make build-frontend`: Builds the Vue.js frontend application.
- `make run-zincsearch`: Starts the ZincSearch server using Docker.
- `make stop-zincsearch`: Stops the ZincSearch server.
- `make run-all`: Runs ZincSearch, the backend, and the frontend.
- `make stop-all`: Stops ZincSearch, the backend, and the frontend.
- `make setup-dataset`: Sets up the Enron Email Dataset.
- `make run-indexer`: Runs the email indexer.

## Usage

After setting up and running the backend, frontend, and ZincSearch, you can access the frontend application at `http://localhost:8080` (or the configured port) to search through the indexed emails.

---

# Servicio de Búsqueda del Dataset de Correos de Enron

## Descripción General

Este servicio permite a los usuarios indexar y buscar en el Dataset de Correos de Enron utilizando un backend en Go, un frontend en Vue.js y ZincSearch para capacidades de búsqueda de texto completo.

## Prerrequisitos

- Go (versión 1.x)
- Node.js y npm
- Docker y Docker Compose
- Acceso al Dataset de Correos de Enron

## Estructura del Proyecto

- `backend/`: Contiene el código en Go para el servidor backend y el indexador de correos.
- `frontend/`: Contiene el código en Vue.js para la aplicación frontend.
- `zincsearch/`: Contiene el archivo Docker Compose para configurar ZincSearch.
- `scripts/`: Contiene scripts de utilidad, incluyendo la configuración del dataset.

## Configuración

### Configuración de ZincSearch

Navegue al directorio `zincsearch` y inicie ZincSearch:

```bash
cd zincsearch
docker-compose up -d
```

### Configuración del Backend

Navegue al directorio `backend`, instale las dependencias de Go y ejecute el servidor backend:

```bash
cd backend
go mod tidy
go run main.go
```

### Configuración del Frontend

Navegue al directorio `frontend`, instale los paquetes npm y ejecute la aplicación Vue.js:

```bash
cd frontend
npm install
npm run serve
```

### Configuración del Dataset

Ejecute el script para descargar y configurar el Dataset de Correos de Enron:

```bash
./scripts/setup-enron-dataset.sh
```

### Ejecución del Indexador

Navegue al directorio del indexador y ejecute el indexador para procesar e indexar los correos:

```bash
cd backend/cmd/indexer
go run main.go
```

## Comandos del Makefile

El Makefile proporcionado simplifica el proceso de construcción y ejecución de diferentes partes de la aplicación:

- `make run-backend`: Ejecuta el servidor backend en Go.
- `make build-backend`: Construye el servidor backend en Go.
- `make test-backend`: Ejecuta pruebas para el backend en Go.
- `make install-frontend`: Instala las dependencias para el frontend en Vue.js.
- `make run-frontend`: Ejecuta la aplicación frontend en Vue.js.
- `make build-frontend`: Construye la aplicación frontend en Vue.js.
- `make run-zincsearch`: Inicia el servidor ZincSearch usando Docker.
- `make stop-zincsearch`: Detiene el servidor ZincSearch.
- `make run-all`: Ejecuta ZincSearch, el backend y el frontend.
- `make stop-all`: Detiene ZincSearch, el backend y el frontend.
- `make setup-dataset`: Configura el Dataset de Correos de Enron.
- `make run-indexer`: Ejecuta el indexador de correos.

## Uso

Después de configurar y ejecutar el backend, el frontend y ZincSearch, puede acceder a la aplicación frontend en `http://localhost:8080` (o el puerto configurado) para buscar en los correos indexados.

---

