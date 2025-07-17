from typing import Any

from fastapi import FastAPI
from fastapi.openapi.utils import get_openapi


# Opcional: si querés forzar un esquema de seguridad visible en Swagger
def custom_openapi(app: FastAPI) -> Any:
    if app.openapi_schema:
        return app.openapi_schema
    openapi_schema = get_openapi(
        title="API de la Tienda",
        version="1.0.0",
        description="Documentación con autenticación JWT",
        routes=app.routes,
    )
    openapi_schema["components"]["securitySchemes"] = {
        "BearerAuth": {"type": "http", "scheme": "bearer", "bearerFormat": "JWT"}
    }
    for path in openapi_schema["paths"].values():
        for method in path.values():
            method["security"] = [{"BearerAuth": []}]
    app.openapi_schema = openapi_schema
    return app.openapi_schema
