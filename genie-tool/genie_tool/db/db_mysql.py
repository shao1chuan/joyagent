# -*- coding: utf-8 -*-
# =====================
# MySQL Database Engine Configuration
# 
# Author: liumin.423
# Date:   2025/9/4
# =====================
import os
from typing import Callable, AsyncGenerator

from loguru import logger
from sqlalchemy import AsyncAdaptedQueuePool, create_engine
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker
from sqlmodel import SQLModel


def get_mysql_config():
    """获取MySQL配置"""
    # 优先使用DATABASE_URL
    database_url = os.environ.get("DATABASE_URL")
    if database_url:
        # 解析DATABASE_URL: mysql+pymysql://user:password@host:port/database?charset=utf8mb4
        import urllib.parse
        parsed = urllib.parse.urlparse(database_url)
        return {
            "host": parsed.hostname,
            "port": str(parsed.port) if parsed.port else "3306",
            "user": parsed.username,
            "password": parsed.password,
            "database": parsed.path.lstrip('/')
        }

    # 回退到单独的环境变量
    host = os.environ.get("MYSQL_HOST", "localhost")
    port = os.environ.get("MYSQL_PORT", "13306")
    user = os.environ.get("MYSQL_USER", "root")
    password = os.environ.get("MYSQL_PASSWORD", "root")
    database = os.environ.get("MYSQL_DATABASE", "jeecg-boot")

    return {
        "host": host,
        "port": port,
        "user": user,
        "password": password,
        "database": database
    }


def create_mysql_engines():
    """创建MySQL同步和异步引擎"""
    config = get_mysql_config()
    
    # 构建连接字符串
    sync_url = f"mysql+pymysql://{config['user']}:{config['password']}@{config['host']}:{config['port']}/{config['database']}?charset=utf8mb4"
    async_url = f"mysql+aiomysql://{config['user']}:{config['password']}@{config['host']}:{config['port']}/{config['database']}?charset=utf8mb4"
    
    # 创建同步引擎
    engine = create_engine(
        sync_url,
        echo=True,
        pool_size=20,
        max_overflow=0,
        pool_pre_ping=True,
        pool_recycle=3600
    )
    
    # 创建异步引擎
    async_engine = create_async_engine(
        async_url,
        poolclass=AsyncAdaptedQueuePool,
        pool_size=20,
        max_overflow=0,
        pool_pre_ping=True,
        pool_recycle=3600,
        echo=False,
    )
    
    return engine, async_engine


def create_mysql_session_factory(async_engine):
    """创建MySQL异步会话工厂"""
    return sessionmaker(bind=async_engine, class_=AsyncSession)


async def get_mysql_async_session(async_session_local: Callable[..., AsyncSession]) -> AsyncGenerator[AsyncSession, None]:
    """MySQL异步session生成器 作为fast api的Depends选项"""
    async with async_session_local() as session:
        yield session


def init_mysql_db(engine):
    """初始化MySQL数据库"""
    from genie_tool.db.file_table import FileInfo
    SQLModel.metadata.create_all(engine)
    logger.info(f"MySQL DB init done")


if __name__ == "__main__":
    engine, async_engine = create_mysql_engines()
    init_mysql_db(engine)