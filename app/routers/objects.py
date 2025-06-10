from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlmodel import select
from app.database import get_session
from app.models import Object
from app.schemas import ObjectCreate, ObjectRead

router = APIRouter(prefix="/objects", tags=["objects"])

@router.post("/", response_model=ObjectRead, status_code=status.HTTP_201_CREATED)
async def create_object(payload: ObjectCreate, session: AsyncSession = Depends(get_session)):
    obj = Object.from_orm(payload)
    session.add(obj)
    await session.commit()
    await session.refresh(obj)
    return obj

@router.get("/", response_model=list[ObjectRead])
async def list_objects(session: AsyncSession = Depends(get_session)):
    result = await session.execute(select(Object))
    return result.scalars().all()
