from fastapi import FastAPI
from contextlib import asynccontextmanager

from app.database import init_db
from app.routers import objects, worklogs

@asynccontextmanager
async def lifespan(app: FastAPI):
    await init_db()
    yield


app = FastAPI(title="MVP Maintenance Backend", lifespan=lifespan)

app.include_router(objects.router)
app.include_router(worklogs.router)

@app.get("/")
async def root():
    return {"status": "ok"}
