
from sqlmodel import SQLModel, Field
from typing import Optional
import datetime as dt

class Object(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    name: str
    address: str
    created_at: dt.datetime = Field(default_factory=dt.datetime.utcnow)

class WorkLog(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    object_id: int = Field(foreign_key="object.id")
    description: str
    performed_at: dt.datetime = Field(default_factory=dt.datetime.utcnow)
