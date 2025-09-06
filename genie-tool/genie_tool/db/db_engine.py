# -*- coding: utf-8 -*-
# =====================
#
#
# Author: liumin.423
# Date:   2025/7/9
# =====================
import os
from typing import Callable, AsyncGenerator

from loguru import logger
from sqlalchemy import AsyncAdaptedQueuePool, create_engine
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker
from sqlmodel import SQLModel


# 获取数据库类型配置
DB_TYPE = os.environ.get("DB_TYPE", "sqlite").lower()

if DB_TYPE == "mysql":
    from genie_tool.db.db_mysql import create_mysql_engines, create_mysql_session_factory
    engine, async_engine = create_mysql_engines()
    async_session_local: Callable[..., AsyncSession] = create_mysql_session_factory(async_engine)
    logger.info("Using MySQL database")
else:
    # 默认使用SQLite
    SQLITE_DB_PATH = os.environ.get("SQLITE_DB_PATH", "autobots.db")
    engine = create_engine(f"sqlite:///{SQLITE_DB_PATH}", echo=True)
    async_engine = create_async_engine(
        f"sqlite+aiosqlite:///{SQLITE_DB_PATH}",
        poolclass=AsyncAdaptedQueuePool,
        pool_size=10,
        pool_recycle=3600,
        echo=False,
    )
    async_session_local: Callable[..., AsyncSession] = sessionmaker(bind=async_engine, class_=AsyncSession)
    logger.info(f"Using SQLite database: {SQLITE_DB_PATH}")


async def get_async_session() -> AsyncGenerator[AsyncSession, None]:
    """session生成器 作为fast api的Depends选项"""
    async with async_session_local() as session:
        yield session


def init_db():
    from genie_tool.db.file_table import FileInfo
    from genie_tool.db.file_user_request import FileUserRequest
    SQLModel.metadata.create_all(engine)
    if DB_TYPE == "mysql":
        logger.info("MySQL DB init done")
    else:
        logger.info(f"SQLite DB init done")


if __name__ == "__main__":
    init_db()
