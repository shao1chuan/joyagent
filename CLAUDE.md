# CLAUDE.md

> Think carefully and implement the most concise solution that changes as little code as possible.

## Project-Specific Instructions

**JoyAgent-JDGenie** is a multi-service agent framework with three main components:

### Architecture
- **genie-backend** (Java Spring Boot 3.2.2): Multi-agent framework with Planning, Executor, ReAct, and Summary agents
- **genie-tool** (Python FastAPI): Tool service providing search, code execution, file management, and report generation
- **ui** (React 19 + TypeScript): Frontend with Ant Design and real-time streaming

### Database Configuration
- **Default**: SQLite (`./genie-tool/autobots.db`)
- **Optional**: MySQL (configured via environment variables)
- **Schema**: FileInfo table tracks all file uploads and metadata
- **Logging**: All database queries are logged in development mode

### Key Development Patterns
- **Tool Integration**: Use MCP (Model Control Protocol) for tool orchestration
- **Streaming**: SSE (Server-Sent Events) for real-time communication
- **File Management**: All files tracked with metadata in database
- **Multi-Modal**: Support for HTML, Markdown, PPT report generation

### Service Communication
```
Frontend :3000 → Backend :8080 → Tool Service :1601 → Database
```

## Testing

Run tests for each component:
- **Backend**: `mvn test` (Java/Maven)
- **Frontend**: `npm test` (React)  
- **Tool Service**: `python -m pytest` (Python/FastAPI)
- **Integration**: Use `./Genie_start.sh` for full stack testing

## Code Style

- **Java**: Follow Spring Boot conventions, use agent pattern for multi-agent orchestration
- **Python**: FastAPI async patterns, SQLModel for database operations
- **TypeScript**: React functional components with hooks, Ant Design components
- **Database**: Track all operations with proper metadata and logging
