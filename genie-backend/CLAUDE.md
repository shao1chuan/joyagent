# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Development Commands

### Build and Package
- **Build project**: `./build.sh` - Compiles project and creates distribution package using Maven with Aliyun mirror
- **Manual build**: `mvn clean package -DskipTests -s aliyun-settings.xml`
- **Test**: `mvn test` - Run unit tests

### Running the Application
- **Start application**: `./start.sh` - Starts the Genie backend service (foreground mode)
- **Background start**: Uncomment the nohup line in start.sh and add `&` at the end
- **Main class**: `com.jd.genie.GenieApplication`
- **Default port**: 8080
- **Health check**: `GET /web/health`

### Development Setup
- **Java version**: 17+ (project uses Java 17, tested with Java 21)
- **Maven version**: 3.x
- **Spring Boot version**: 3.2.2

## Architecture Overview

### Multi-Agent System
The application implements a sophisticated multi-agent architecture with the following key components:

#### Agent Types
- **PlanningAgent**: Task decomposition and planning (拆解任务列表)
- **ExecutorAgent**: Task execution with tool calling capabilities
- **ReActAgent**: Reasoning-Action-Observation pattern implementation
- **SummaryAgent**: Task result summarization

#### Tool System
The system includes built-in tools for various capabilities:
- **FileTool**: File read/write operations (text, markdown, csv)
- **CodeInterpreterTool**: Python code execution and data analysis
- **DeepSearchTool**: Internet search capabilities
- **ReportTool**: Generate HTML, Markdown, and PowerPoint reports
- **McpTool**: Model Control Protocol tool integration

#### Core Architecture
- **AgentContext**: Central context management for agent execution
- **ToolCollection**: Tool registry and execution management
- **Memory**: Conversation history and context preservation
- **Printer**: SSE-based streaming output (SSEPrinter, LogPrinter)

### Configuration
- **Application config**: `src/main/resources/application.yml`
- **LLM settings**: Configure base_url, apikey, and model parameters
- **External service URLs**:
  - `code_interpreter_url`: http://127.0.0.1:1601
  - `deep_search_url`: http://127.0.0.1:1601  
  - `mcp_client_url`: http://127.0.0.1:8188

### API Endpoints
- **Main agent endpoint**: `POST /AutoAgent` - Multi-agent task processing with SSE streaming
- **Legacy endpoint**: `POST /web/api/v1/gpt/queryAgentStreamIncr` - Alternative agent query interface
- **Health check**: `GET /web/health`

### Assembly and Deployment
The project uses Maven Assembly plugin to create a structured deployment package:
- `bin/`: Startup scripts
- `conf/`: Configuration files
- `lib/`: JAR dependencies and main application JAR

### Key Design Patterns
- **Agent Factory Pattern**: `AgentHandlerFactory` for agent type selection
- **Tool Pattern**: Extensible tool system with common interface
- **Observer Pattern**: Memory system for conversation tracking
- **Strategy Pattern**: Different response handlers for agent types

### Testing
- Test files located in: `src/test/java/com/jd/genie/controller/`
- Run tests with: `mvn test`
- **Note**: Tests may show connection errors to external services (MCP, code interpreter, search) which is expected if those services aren't running
- Use `mvn install -DskipTests` to build without running tests

## Important Notes
- The system requires external services (code interpreter, search, MCP) to be running on specified ports
- All agent prompts and configurations are externalized in application.yml
- The application supports both Chinese and English but defaults to Chinese output
- SSE streaming is used for real-time agent output and heartbeat monitoring