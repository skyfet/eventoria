from fastapi import FastAPI
from app.database import init_db
from app.routers import objects, worklogs
import asyncio

app = FastAPI(title="MVP Maintenance Backend")

@app.on_event("startup")
async def on_startup():
    await init_db()

app.include_router(objects.router)
app.include_router(worklogs.router)

@app.get("/")
async def root():
    return {"status": "ok"}
