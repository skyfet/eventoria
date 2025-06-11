
from sqlmodel import SQLModel
import datetime as dt
from typing import Optional

class ObjectCreate(SQLModel):
    name: str
    address: str
    owner_org_id: Optional[int] = None

class ObjectRead(ObjectCreate):
    id: int
    created_at: dt.datetime

class WorkLogCreate(SQLModel):
    work_order_id: int
    performer_id: int
    description: str
    performed_at: Optional[dt.datetime] = None

class WorkLogRead(WorkLogCreate):
    id: int
