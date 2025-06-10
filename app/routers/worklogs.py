
from fastapi import APIRouter, Depends, HTTPException, status
from sqlmodel import Session, select
from app.database import get_session
from app.models import WorkLog, Object
from app.schemas import WorkLogCreate, WorkLogRead

router = APIRouter(prefix="/worklogs", tags=["worklogs"])

@router.post("/", response_model=WorkLogRead, status_code=status.HTTP_201_CREATED)
def create_log(payload: WorkLogCreate, session: Session = Depends(get_session)):
    # simple existence check
    obj = session.get(Object, payload.object_id)
    if not obj:
        raise HTTPException(status_code=404, detail="Object not found")
    log = WorkLog(**payload.dict())
    session.add(log)
    session.commit()
    session.refresh(log)
    return log

@router.get("/", response_model=list[WorkLogRead])
def list_logs(session: Session = Depends(get_session)):
    return session.exec(select(WorkLog)).all()
