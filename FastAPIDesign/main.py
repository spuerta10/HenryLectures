import uvicorn
from fastapi import FastAPI
from src.database import DataBase
from src.docs.swagger import custom_openapi
from src.routers.auth import router as auth_router
from src.routers.client import router as client_router
from src.routers.order import router as order_router
from src.routers.product import router as product_router

if __name__ == "__main__":
    DataBase.connect(r"data/dataset_tienda.json")

    app = FastAPI()
    app.openapi = lambda: custom_openapi(app)
    app.include_router(auth_router, prefix="/api/v1")
    app.include_router(client_router, prefix="/api/v1")
    app.include_router(order_router, prefix="/api/v1")
    app.include_router(product_router, prefix="/api/v1")
    uvicorn.run(app, host="0.0.0.0")  # noqa
