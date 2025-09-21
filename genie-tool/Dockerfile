FROM python:3.11-slim

# 设置工作目录
WORKDIR /app

# 安装系统依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    netcat-openbsd \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 安装uv包管理器
RUN pip install uv

# 复制依赖文件
COPY pyproject.toml uv.lock ./

# 创建虚拟环境并安装依赖
RUN uv venv .venv && \
    . .venv/bin/activate && \
    uv sync

# 复制源代码
COPY genie_tool ./genie_tool
COPY server.py ./

# 创建数据目录
RUN mkdir -p /data/genie-tool /app/logs /app/file_db_dir

# 设置环境变量
ENV PATH="/app/.venv/bin:$PATH"
ENV PYTHONPATH="/app"

# 暴露端口
EXPOSE 1601

# 健康检查 - 使用根路径或实际可用的端点
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD curl -f http://localhost:1601/v1/tool/ || exit 1

# 创建启动脚本
RUN echo '#!/bin/bash\n\
set -e\n\
\n\
echo "Initializing database..."\n\
# Initialize database if using MySQL\n\
if [ "$DB_TYPE" = "mysql" ]; then\n\
  python -m genie_tool.db.db_engine || echo "Database initialization completed or already exists"\n\
fi\n\
\n\
# Start the server\n\
echo "Starting Genie Tool server..."\n\
exec python server.py --host 0.0.0.0 --port 1601\n\
' > /app/start.sh && chmod +x /app/start.sh

# 启动命令
CMD ["/app/start.sh"]