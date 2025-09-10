\c sensors_logs_db;

-- Tabla de aterrizaje (landing table)
-- Aquí llega el JSON sin transformar
CREATE TABLE landing_logs (
    raw_payload JSONB NOT NULL,
    ingested_at TIMESTAMP DEFAULT NOW()
);

-- Tabla de sensores
CREATE TABLE sensors (
    sensor_id SERIAL PRIMARY KEY,
    sensor_name VARCHAR(100) NOT NULL,
    description TEXT
);

-- Tabla de tipos de eventos
CREATE TABLE event_types (
    event_type_id SERIAL PRIMARY KEY,
    event_name VARCHAR(50) NOT NULL
);

-- Tabla de eventos de sensores (ya transformados)
CREATE TABLE sensor_events (
    event_id SERIAL PRIMARY KEY,
    sensor_id INT NOT NULL REFERENCES sensors(sensor_id),
    event_type_id INT NOT NULL REFERENCES event_types(event_type_id),
    timestamp TIMESTAMP NOT NULL,
    duration_seconds INT
);