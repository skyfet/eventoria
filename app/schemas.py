
from sqlmodel import SQLModel
import datetime as dt
from typing import Optional

class ObjectCreate(SQLModel):
    name: str
    address: str

class ObjectRead(ObjectCreate):
    id: int
    created_at: dt.datetime

class WorkLogCreate(SQLModel):
    object_id: int
    description: str
    performed_at: Optional[dt.datetime] = None

class WorkLogRead(WorkLogCreate):
    id: int
