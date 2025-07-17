from fastapi import APIRouter, HTTPException

from src.database import DataBase

router = APIRouter()
db = DataBase()


@router.delete("/clientes/{id}")
def delete_client(id: int) -> dict:
    clients: list[dict] = db.fetch_data("clientes")
    for client in clients:
        if client["id"] == id:
            clients.remove(client)
            return {"status": "success", "message": "Cliente eliminado correctamente", "data": None}

    raise HTTPException(status_code=404, detail="Cliente no encontrado")
