import json
from os.path import exists
from typing import Any, ClassVar


class DataBase:
    DB_PATH: ClassVar[None | str] = None

    @classmethod
    def connect(cls, db_path: str) -> None:
        assert exists(db_path), "Database does not exist"
        cls.DB_PATH = db_path

    @classmethod
    def fetch_data(cls, table: str) -> Any:
        assert cls.DB_PATH, "Database not connected"

        with open(cls.DB_PATH) as file:
            data: dict = json.load(file)

        return data.get(table, {})
