from os import getenv

import uvicorn
from mangum import Mangum
from src.application.api import API
from src.services.log_pruner import LogPruner
from src.services.sqlite_conn import SQliteConn
from src.services.temporal_cache import TemporalCache

pruner: LogPruner = LogPruner(window_minutes=5)
cache: TemporalCache = TemporalCache(pruner=pruner)
sqlite: SQliteConn = SQliteConn(db_path=r"data/logs.db")
api: API = API(cache=cache, db_service=sqlite)

handler = Mangum(api.app)

if getenv("RUNENV", "") == "local":
    uvicorn.run(api.app, host="0.0.0.0", port=int(getenv("PORT", "80")))  # noqa: S104
