from datetime import datetime, timedelta
from typing import Any

from fastapi import APIRouter, Depends, HTTPException
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from jose import JWTError, jwt

from src.database import DataBase

SECRET_KEY: str = "secretkey123"  # noqa
ALGORITHM: str = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES: int = 30

router = APIRouter()
db = DataBase()

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")


# Función para autenticar al usuario
def authenticate_user(email: str, password: str) -> Any | None:
    users: dict = db.fetch_data("usuarios")
    user: Any[dict] = users.get(email)
    if not user or user["password"] != password:
        return None
    return user


# Crear el token JWT
def create_access_token(data: dict, expires_delta: timedelta) -> Any:
    to_encode = data.copy()
    expire = datetime.utcnow() + expires_delta
    to_encode.update({"exp": expire})
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)


# Endpoint de login
@router.post("/token")
def login(form_data: OAuth2PasswordRequestForm = Depends()) -> dict:  # noqa
    user = authenticate_user(form_data.username, form_data.password)
    if not user:
        raise HTTPException(status_code=400, detail="Credenciales inválidas")

    access_token = create_access_token(
        data={"sub": user["email"]}, expires_delta=timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    )

    return {"access_token": access_token, "token_type": "bearer"}


# Obtener el usuario desde el token
def get_current_user(token: str = Depends(oauth2_scheme)) -> dict:
    try:
        payload: dict = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        email: Any[str] = payload.get("sub")
        user: dict = db.fetch_data("usuarios").get(email)
        if not user:
            raise HTTPException(status_code=401, detail="Usuario no encontrado")
    except JWTError as err:
        raise HTTPException(status_code=401, detail="Token inválido") from err
    else:
        return user


# Ruta protegida
@router.get("/me")
def read_me(current_user: dict = Depends(get_current_user)) -> dict:  # noqa
    return {
        "id": current_user["id"],
        "nombre": current_user["nombre"],
        "email": current_user["email"],
    }
