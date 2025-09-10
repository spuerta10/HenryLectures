\c sensors_logs_db;

COPY landing_logs (raw_payload)
FROM '/data/logs.jsonl'
WITH (FORMAT text);
