# -*- coding: utf-8 -*-
# =====================
# 
# 
# Author: liumin.423
# Date:   2025/9/6
# =====================
from datetime import datetime
from typing import Optional

from sqlmodel import select

from genie_tool.db.file_user_request import FileUserRequest
from genie_tool.db.db_engine import async_session_local
from genie_tool.util.log_util import timer


class FileUserRequestOp(object):

    @staticmethod
    @timer()
    async def add(file_user_request: FileUserRequest) -> FileUserRequest:
        """添加用户请求记录"""
        async with async_session_local() as session:
            session.add(file_user_request)
            await session.commit()
            await session.refresh(file_user_request)
        return file_user_request

    @staticmethod
    @timer()
    async def create_user_request(
        username: str,
        request_id: str,
        create_time: Optional[datetime] = None
    ) -> FileUserRequest:
        """创建用户请求记录"""
        if create_time is None:
            create_time = datetime.now()
        
        file_user_request = FileUserRequest(
            username=username,
            request_id=request_id,
            create_time=create_time
        )
        return await FileUserRequestOp.add(file_user_request)

    @staticmethod
    @timer()
    async def get_by_request_id(request_id: str) -> Optional[FileUserRequest]:
        """根据request_id获取用户请求记录"""
        async with async_session_local() as session:
            state = select(FileUserRequest).where(FileUserRequest.request_id == request_id)
            result = await session.execute(state)
            return result.scalars().one_or_none()

    @staticmethod
    @timer()
    async def get_by_username(username: str) -> list[FileUserRequest]:
        """根据username获取用户请求记录列表"""
        async with async_session_local() as session:
            state = select(FileUserRequest).where(FileUserRequest.username == username)
            result = await session.execute(state)
            return result.scalars().all()