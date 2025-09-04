# -*- coding: utf-8 -*-
# =====================
# 
# 
# Author: liumin.423
# Date:   2025/9/4
# =====================
from datetime import datetime
from typing import List, Optional

from sqlmodel import select
from sqlalchemy import desc, asc

from genie_tool.db.conversation_table import UserConversation
from genie_tool.db.db_engine import async_session_local
from genie_tool.util.log_util import timer


class ConversationOp(object):
    """CRUD operations for UserConversation model"""

    @staticmethod
    @timer()
    async def add(conversation: UserConversation) -> UserConversation:
        """Add or update a conversation record"""
        request_id = conversation.request_id
        existing = await ConversationOp.get_by_request_id(request_id)
        
        async with async_session_local() as session:
            if existing:
                # Update existing record
                existing.conversation_title = conversation.conversation_title
                existing.conversation_content = conversation.conversation_content
                existing.conversation_metadata = conversation.conversation_metadata
                existing.status = conversation.status
                existing.processing_start_time = conversation.processing_start_time
                existing.processing_end_time = conversation.processing_end_time
                existing.update_time = datetime.now()
                session.add(existing)
            else:
                # Add new record
                session.add(conversation)
            await session.commit()
        return await ConversationOp.get_by_request_id(request_id)

    @staticmethod
    @timer()
    async def create_conversation(request_id: str, user_id: str = None, 
                                conversation_title: str = None, 
                                conversation_content: str = None,
                                conversation_metadata: str = None) -> UserConversation:
        """Create a new conversation with basic information"""
        conversation = UserConversation(
            request_id=request_id,
            user_id=user_id,
            conversation_title=conversation_title,
            conversation_content=conversation_content,
            conversation_metadata=conversation_metadata,
            status=0  # pending
        )
        return await ConversationOp.add(conversation)

    @staticmethod
    @timer()
    async def get_by_request_id(request_id: str) -> Optional[UserConversation]:
        """Get conversation by request_id"""
        async with async_session_local() as session:
            stmt = select(UserConversation).where(UserConversation.request_id == request_id)
            result = await session.execute(stmt)
            return result.scalars().one_or_none()

    @staticmethod
    @timer()
    async def get_by_id(conversation_id: int) -> Optional[UserConversation]:
        """Get conversation by primary key id"""
        async with async_session_local() as session:
            stmt = select(UserConversation).where(UserConversation.id == conversation_id)
            result = await session.execute(stmt)
            return result.scalars().one_or_none()

    @staticmethod
    @timer()
    async def get_by_user_id(user_id: str, limit: int = 100, offset: int = 0, 
                           order_by: str = 'create_time', order_desc: bool = True) -> List[UserConversation]:
        """Get conversations by user_id with pagination and ordering"""
        async with async_session_local() as session:
            stmt = select(UserConversation).where(UserConversation.user_id == user_id)
            
            # Apply ordering
            if order_by == 'create_time':
                order_column = UserConversation.create_time
            elif order_by == 'update_time':
                order_column = UserConversation.update_time
            else:
                order_column = UserConversation.create_time
                
            if order_desc:
                stmt = stmt.order_by(desc(order_column))
            else:
                stmt = stmt.order_by(asc(order_column))
                
            stmt = stmt.offset(offset).limit(limit)
            
            result = await session.execute(stmt)
            return result.scalars().all()

    @staticmethod
    @timer()
    async def get_by_status(status: int, limit: int = 100, offset: int = 0) -> List[UserConversation]:
        """Get conversations by status with pagination"""
        async with async_session_local() as session:
            stmt = select(UserConversation).where(UserConversation.status == status)
            stmt = stmt.order_by(desc(UserConversation.create_time))
            stmt = stmt.offset(offset).limit(limit)
            result = await session.execute(stmt)
            return result.scalars().all()

    @staticmethod
    @timer()
    async def get_by_user_and_status(user_id: str, status: int, 
                                   limit: int = 100, offset: int = 0) -> List[UserConversation]:
        """Get conversations by user_id and status with pagination"""
        async with async_session_local() as session:
            stmt = select(UserConversation).where(
                UserConversation.user_id == user_id,
                UserConversation.status == status
            )
            stmt = stmt.order_by(desc(UserConversation.create_time))
            stmt = stmt.offset(offset).limit(limit)
            result = await session.execute(stmt)
            return result.scalars().all()

    @staticmethod
    @timer()
    async def update_status(request_id: str, status: int, 
                          processing_start_time: datetime = None,
                          processing_end_time: datetime = None) -> Optional[UserConversation]:
        """Update conversation status and processing timestamps"""
        existing = await ConversationOp.get_by_request_id(request_id)
        if not existing:
            return None
            
        async with async_session_local() as session:
            existing.status = status
            existing.update_time = datetime.now()
            
            if processing_start_time is not None:
                existing.processing_start_time = processing_start_time
            elif status == 1:  # processing status
                existing.processing_start_time = datetime.now()
                
            if processing_end_time is not None:
                existing.processing_end_time = processing_end_time
            elif status in [2, 3]:  # completed or failed status
                existing.processing_end_time = datetime.now()
                
            session.add(existing)
            await session.commit()
        return await ConversationOp.get_by_request_id(request_id)

    @staticmethod
    @timer()
    async def update_content(request_id: str, conversation_content: str = None,
                           conversation_metadata: str = None) -> Optional[UserConversation]:
        """Update conversation content and metadata"""
        existing = await ConversationOp.get_by_request_id(request_id)
        if not existing:
            return None
            
        async with async_session_local() as session:
            if conversation_content is not None:
                existing.conversation_content = conversation_content
            if conversation_metadata is not None:
                existing.conversation_metadata = conversation_metadata
            existing.update_time = datetime.now()
            session.add(existing)
            await session.commit()
        return await ConversationOp.get_by_request_id(request_id)

    @staticmethod
    @timer()
    async def delete_by_request_id(request_id: str) -> bool:
        """Delete conversation by request_id"""
        existing = await ConversationOp.get_by_request_id(request_id)
        if not existing:
            return False
            
        async with async_session_local() as session:
            await session.delete(existing)
            await session.commit()
        return True

    @staticmethod
    @timer()
    async def count_by_user_id(user_id: str, status: int = None) -> int:
        """Count conversations for a user, optionally filtered by status"""
        async with async_session_local() as session:
            stmt = select(UserConversation).where(UserConversation.user_id == user_id)
            if status is not None:
                stmt = stmt.where(UserConversation.status == status)
            result = await session.execute(stmt)
            return len(result.scalars().all())

    @staticmethod
    @timer()
    async def get_recent_conversations(limit: int = 10, user_id: str = None) -> List[UserConversation]:
        """Get recent conversations, optionally filtered by user_id"""
        async with async_session_local() as session:
            stmt = select(UserConversation)
            if user_id:
                stmt = stmt.where(UserConversation.user_id == user_id)
            stmt = stmt.order_by(desc(UserConversation.create_time)).limit(limit)
            result = await session.execute(stmt)
            return result.scalars().all()