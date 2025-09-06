# -*- coding: utf-8 -*-
# =====================
# 
# 
# Author: liumin.423
# Date:   2025/9/6
# =====================
from datetime import datetime
from typing import Optional

from sqlalchemy import DateTime, text
from sqlmodel import SQLModel, Field


class FileUserRequest(SQLModel, table=True):
    __tablename__ = "file_user_request"
    
    id: int | None = Field(default=None, primary_key=True)
    username: Optional[str] = Field(default=None, max_length=20)
    request_id: Optional[str] = Field(default=None, max_length=100)
    suggestion: Optional[str] = Field(default=None, max_length=500)
    summary: Optional[str] = Field(default=None, max_length=500)
    direction: Optional[str] = Field(default=None, max_length=500)
    supervisor: Optional[str] = Field(default=None, max_length=20)
    create_time: Optional[datetime] = Field(
        sa_type=DateTime, default=None, nullable=True, sa_column_kwargs={"server_default": text("CURRENT_TIMESTAMP")}
    )