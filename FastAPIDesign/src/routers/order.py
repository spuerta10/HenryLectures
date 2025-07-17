from fastapi import APIRouter

from src.database import DataBase

router = APIRouter()
db = DataBase()


@router.post("/ordenes")
def create_order() -> dict:
    orders: list[dict] = db.fetch_data("ordenes")
    new_order: dict = {
        "id": len(orders) + 1,
        "cliente_id": 1,  # se puede parametrizar en versiones futuras
        "producto_id": 2,
        "cantidad": 1,
        "total": 1000.0,
        "fecha": "2025-06-29",
    }
    orders.append(new_order)

    return {"status": "success", "data": new_order, "message": "Orden creada correctamente"}
