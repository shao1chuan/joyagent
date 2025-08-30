# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Genie Tool is a FastAPI-based AI tool service that provides intelligent document processing, code interpretation, and deep search capabilities. It's built with Python 3.11+ and uses SQLite for data storage.

## Development Commands

### Environment Setup
```bash
pip install uv
cd genie-tool
uv sync
source .venv/bin/activate  # On Windows: .venv\Scripts\activate
```

### Database Initialization
First-time setup only:
```bash
python -m genie_tool.db.db_engine
```

### Running the Server
```bash
# Copy environment template and configure
cp .env_template .env

# Start the development server
uv run python server.py

# Or use the startup script
./start.sh
```

### Server Configuration
- Default host: 0.0.0.0
- Default port: 1601
- Default workers: 10
- Reload enabled in local environment

## Architecture

### Core Components
- **API Layer** (`genie_tool/api/`): FastAPI routers for tool and file management endpoints
- **Tool Layer** (`genie_tool/tool/`): Core business logic including:
  - `code_interpreter.py`: Python code execution with smolagents
  - `deepsearch.py`: Multi-engine search with query decomposition and reasoning
  - `report.py`: Document analysis and reporting
- **Database** (`genie_tool/db/`): SQLite with async support via aiosqlite
- **Models** (`genie_tool/model/`): Pydantic models for protocols and data structures
- **Utils** (`genie_tool/util/`): Common utilities for LLM calls, file handling, logging

### Key Features
1. **Code Interpreter**: Uses smolagents with LiteLLM for executing Python code with file uploads
2. **Deep Search**: Multi-stage search process with query decomposition, web search, reasoning, and answer synthesis
3. **File Management**: Upload/download system with SQLite metadata storage
4. **LLM Integration**: Supports multiple providers via LiteLLM (OpenAI, DeepSeek, Anthropic)

### Configuration
Environment variables are defined in `.env_template`:
- Model configuration (DEFAULT_MODEL, various tool-specific models)
- Search engine settings (SERPER, BING, JINA, SOGOU APIs)
- File system paths and database location
- Sensitive word filtering options

### API Structure
- Base path: `/v1`
- Tool endpoints: `/v1/tool/*`
- File management: `/v1/file_tool/*`

### Database Schema
SQLite database with async operations, file metadata storage, and connection pooling.

## Important Notes
- No test files are present in the codebase
- Uses CORS middleware allowing all origins
- Logging configured with rotation (200MB files)
- Temporary directories used for code execution isolation
- Sensitive content filtering available