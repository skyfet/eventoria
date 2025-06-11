
from fastapi import APIRouter, Depends, HTTPException, status
from sqlmodel import Session, select
from app.database import get_session
from app.models import WorkLog, WorkOrder
from app.schemas import WorkLogCreate, WorkLogRead

router = APIRouter(prefix="/worklogs", tags=["worklogs"])

@router.post("/", response_model=WorkLogRead, status_code=status.HTTP_201_CREATED)
def create_log(payload: WorkLogCreate, session: Session = Depends(get_session)):
    # ensure referenced work order exists
    order = session.get(WorkOrder, payload.work_order_id)
    if not order:
        raise HTTPException(status_code=404, detail="Work order not found")
    log = WorkLog(**payload.dict())
    session.add(log)
    session.commit()
    session.refresh(log)
    return log

@router.get("/", response_model=list[WorkLogRead])
def list_logs(session: Session = Depends(get_session)):
    return session.exec(select(WorkLog)).all()
