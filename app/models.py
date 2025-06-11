import datetime as dt
from enum import Enum
from typing import Optional
from sqlmodel import Field, SQLModel, Relationship


class ServiceType(str, Enum):
    TO1 = "TO-1"
    TO2 = "TO-2"
    CHECK = "CHECK"
    REPAIR = "REPAIR"


class PlanPeriodicity(str, Enum):
    MONTHLY = "MONTHLY"
    QUARTERLY = "QUARTERLY"
    YEARLY = "YEARLY"


class Severity(str, Enum):
    LOW = "LOW"
    MEDIUM = "MEDIUM"
    HIGH = "HIGH"
    CRITICAL = "CRITICAL"


class Object(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    name: str
    address: str
    owner_org_id: Optional[int] = Field(foreign_key="user.id")
    created_at: dt.datetime = Field(default_factory=dt.datetime.utcnow)

    systems: list["System"] = Relationship(back_populates="object")


class System(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    object_id: int = Field(foreign_key="object.id")
    type: str  # e.g. FIRE_ALARM
    model: str
    serial_no: str
    installed_at: Optional[dt.date]
    object: Object = Relationship(back_populates="systems")

    plans: list["MaintenancePlan"] = Relationship(back_populates="system")
    incidents: list["Incident"] = Relationship(back_populates="system")


class MaintenancePlan(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    system_id: int = Field(foreign_key="system.id")
    service_type: ServiceType
    periodicity: PlanPeriodicity
    next_due: dt.date
    active: bool = True

    system: System = Relationship(back_populates="plans")
    work_orders: list["WorkOrder"] = Relationship(back_populates="plan")


class WorkOrderStatus(str, Enum):
    PENDING = "PENDING"
    IN_PROGRESS = "IN_PROGRESS"
    DONE = "DONE"
    CANCELLED = "CANCELLED"


class WorkOrder(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    plan_id: Optional[int] = Field(foreign_key="maintenanceplan.id")
    incident_id: Optional[int] = Field(foreign_key="incident.id")
    scheduled_for: dt.date
    status: WorkOrderStatus = Field(default=WorkOrderStatus.PENDING)

    plan: Optional[MaintenancePlan] = Relationship(back_populates="work_orders")
    log: Optional["WorkLog"] = Relationship(back_populates="work_order", sa_relationship_kwargs={"uselist": False})


class WorkLog(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    work_order_id: int = Field(foreign_key="workorder.id")
    performed_at: dt.datetime = Field(default_factory=dt.datetime.utcnow)
    performer_id: int = Field(foreign_key="user.id")
    description: str

    work_order: WorkOrder = Relationship(back_populates="log")
    performer: "User" = Relationship(back_populates="work_logs")


class Incident(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    system_id: int = Field(foreign_key="system.id")
    severity: Severity
    opened_at: dt.datetime = Field(default_factory=dt.datetime.utcnow)
    closed_at: Optional[dt.datetime]
    root_cause: Optional[str]

    system: System = Relationship(back_populates="incidents")
    actions: list["IncidentAction"] = Relationship(back_populates="incident")


class IncidentAction(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    incident_id: int = Field(foreign_key="incident.id")
    action_at: dt.datetime = Field(default_factory=dt.datetime.utcnow)
    comment: str
    user_id: int = Field(foreign_key="user.id")

    incident: Incident = Relationship(back_populates="actions")
    user: "User" = Relationship(back_populates="incident_actions")


class User(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    username: str
    role: str
    cert_thumbprint: Optional[str]

    work_logs: list[WorkLog] = Relationship(back_populates="performer")
    incident_actions: list[IncidentAction] = Relationship(back_populates="user")


class File(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    s3_key: str  # path in MinIO
    mime: str
    size: int
    sha256: str
    uploaded_at: dt.datetime = Field(default_factory=dt.datetime.utcnow)


class FileLink(SQLModel, table=True):
    __tablename__ = "file_links"
    file_id: int = Field(foreign_key="file.id", primary_key=True)
    entity: str = Field(primary_key=True)  # e.g. "work_log", "incident"
    entity_id: int = Field(primary_key=True)
    purpose: str  # ACT, PHOTO, SIGNED_PDF


class SignatureRecord(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    file_id: int = Field(foreign_key="file.id")
    signed_by: int = Field(foreign_key="user.id")
    tsa: dt.datetime
    signature_blob: bytes
