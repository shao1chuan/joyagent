# -*- coding: utf-8 -*-
# =====================
# 
# 
# Author: liumin.423
# Date:   2025/9/4
# =====================
from datetime import datetime
from typing import Optional

from sqlalchemy import DateTime, text, Index
from sqlmodel import SQLModel, Field


class UserConversation(SQLModel, table=True):
    """User conversation model for storing conversation details and metadata"""
    
    id: int | None = Field(default=None, primary_key=True)
    request_id: str = Field(unique=True, nullable=False, index=True)
    user_id: Optional[str] = Field(default=None, index=True)
    conversation_title: Optional[str] = Field(default=None)
    conversation_content: Optional[str] = Field(default=None)
    conversation_metadata: Optional[str] = Field(default=None)  # JSON string for additional metadata
    status: int = Field(default=0, index=True)  # 0: pending, 1: processing, 2: completed, 3: failed
    processing_start_time: Optional[datetime] = Field(sa_type=DateTime, default=None, nullable=True)
    processing_end_time: Optional[datetime] = Field(sa_type=DateTime, default=None, nullable=True)
    create_time: Optional[datetime] = Field(
        sa_type=DateTime, default=None, nullable=False, sa_column_kwargs={"server_default": text("CURRENT_TIMESTAMP")}
    )
    update_time: Optional[datetime] = Field(
        sa_type=DateTime, default=None, nullable=True, 
        sa_column_kwargs={"server_default": text("CURRENT_TIMESTAMP"), "onupdate": text("CURRENT_TIMESTAMP")}
    )

    # Performance indexes
    __table_args__ = (
        Index('idx_user_status', 'user_id', 'status'),
        Index('idx_user_create_time', 'user_id', 'create_time'),
        Index('idx_status_create_time', 'status', 'create_time'),
    )