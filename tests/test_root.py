
from fastapi.testclient import TestClient

import os
import sys
import asyncio
import tempfile
import datetime as dt
from typing import Generator

import pytest

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

temp_db = tempfile.NamedTemporaryFile(delete=False)
os.environ["DATABASE_URL"] = f"sqlite+aiosqlite:///{temp_db.name}"


@pytest.fixture(scope="session", autouse=True)
def _cleanup() -> Generator[None, None, None]:
    yield
    try:
        os.unlink(temp_db.name)
    except FileNotFoundError:
        pass

from app.main import app
from app.database import async_session
from app.models import WorkOrder


@pytest.fixture(scope="module")
def client() -> Generator[TestClient, None, None]:
    with TestClient(app) as c:
        yield c


def test_root(client: TestClient):
    r = client.get("/")
    assert r.status_code == 200
    assert r.json() == {"status": "ok"}


def test_object_crud(client: TestClient):
    r = client.post("/objects/", json={"name": "Obj1", "address": "Addr"})
    assert r.status_code == 201
    created = r.json()

    r = client.get("/objects/")
    assert r.status_code == 200
    assert any(o["id"] == created["id"] for o in r.json())


def test_worklog_flow(client: TestClient):
    async def create_order():
        async with async_session() as session:
            wo = WorkOrder(scheduled_for=dt.date.today())
            session.add(wo)
            await session.commit()
            await session.refresh(wo)
            return wo.id

    wo_id = asyncio.run(create_order())

    r = client.post(
        "/worklogs/",
        json={"work_order_id": wo_id, "performer_id": 1, "description": "test"},
    )
    assert r.status_code == 201

    r = client.get("/worklogs/")
    assert r.status_code == 200
    assert any(l["work_order_id"] == wo_id for l in r.json())

