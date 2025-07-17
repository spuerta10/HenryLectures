from fastapi import APIRouter

from src.database import DataBase

router = APIRouter()
db = DataBase()


@router.get("/productos")
def list_products() -> dict:
    products: dict = db.fetch_data("productos")
    return {"status": "success", "data": products, "message": None}
