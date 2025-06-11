
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlmodel import select
from app.database import get_session
from app.models import WorkLog, WorkOrder
from app.schemas import WorkLogCreate, WorkLogRead

router = APIRouter(prefix="/worklogs", tags=["worklogs"])

@router.post("/", response_model=WorkLogRead, status_code=status.HTTP_201_CREATED)
async def create_log(
    payload: WorkLogCreate,
    session: AsyncSession = Depends(get_session),
):
    # ensure referenced work order exists
    order = await session.get(WorkOrder, payload.work_order_id)
    if not order:
        raise HTTPException(status_code=404, detail="Work order not found")
    log = WorkLog(**payload.dict())
    session.add(log)
    await session.commit()
    await session.refresh(log)
    return log

@router.get("/", response_model=list[WorkLogRead])
async def list_logs(session: AsyncSession = Depends(get_session)):
    result = await session.execute(select(WorkLog))
    return result.scalars().all()
