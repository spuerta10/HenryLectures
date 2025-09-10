CREATE OR REPLACE FUNCTION get_sensor_failure_duration(
    p_sensor_id INT,
    p_date DATE
)
RETURNS NUMERIC AS $$
DECLARE
    v_has_logs BOOLEAN;
    v_start NUMERIC;
    v_end NUMERIC;
BEGIN
    -- ¿Hay cualquier log ese día?
    SELECT EXISTS (
        SELECT 1
        FROM sensor_events se
        WHERE se.sensor_id = p_sensor_id
          AND se.timestamp >= p_date
          AND se.timestamp <  p_date + INTERVAL '1 day'
    ) INTO v_has_logs;

    IF NOT v_has_logs THEN
        RETURN NULL; -- igual que tu Python cuando no hay logs
    END IF;

    -- Primer FAILURE_START del día (o 0 si no hay)
    SELECT se.duration_seconds
    INTO v_start
    FROM sensor_events se
    JOIN event_types et ON et.event_type_id = se.event_type_id
    WHERE se.sensor_id = p_sensor_id
      AND se.timestamp >= p_date
      AND se.timestamp <  p_date + INTERVAL '1 day'
      AND et.event_name = 'FAILURE_START'
    ORDER BY se.timestamp ASC
    LIMIT 1;

    -- Primer FAILURE_END del día (o 0 si no hay)
    SELECT se.duration_seconds
    INTO v_end
    FROM sensor_events se
    JOIN event_types et ON et.event_type_id = se.event_type_id
    WHERE se.sensor_id = p_sensor_id
      AND se.timestamp >= p_date
      AND se.timestamp <  p_date + INTERVAL '1 day'
      AND et.event_name = 'FAILURE_END'
    ORDER BY se.timestamp ASC
    LIMIT 1;

    RETURN ABS(COALESCE(v_end, 0) - COALESCE(v_start, 0));
END;
$$ LANGUAGE plpgsql STABLE;

CREATE OR REPLACE FUNCTION get_weekly_sensor_failure_duration(
    p_sensor_id INT,
    p_start_date DATE,
    p_end_date DATE DEFAULT NULL
)
RETURNS TABLE (
    sensor_id INT,
    date DATE,
    failure_seconds NUMERIC
) AS $$
BEGIN
    -- Si no se pasa fecha final, usar start_date + 7 días
    IF p_end_date IS NULL THEN
        p_end_date := p_start_date + INTERVAL '7 days';
    END IF;

    RETURN QUERY
    WITH dates AS (
        SELECT generate_series(p_start_date, p_end_date - INTERVAL '1 day', INTERVAL '1 day')::date AS day
    )
    SELECT
        p_sensor_id AS sensor_id,
        d.day AS date,
        get_sensor_failure_duration(p_sensor_id, d.day) AS failure_seconds
    FROM dates d;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_conditional_failure_probability(
    p_sensor_a_id INT,
    p_sensor_b_id INT,
    p_start_date DATE,
    p_failure_minutes_threshold NUMERIC DEFAULT 3
)
RETURNS NUMERIC AS $$
DECLARE
    v_failure_seconds_threshold NUMERIC;
    v_count_b_failures INT;
    v_count_a_b_failures INT;
BEGIN
    v_failure_seconds_threshold := p_failure_minutes_threshold * 60;

    -- contar cuántos días falló B
    SELECT COUNT(*)
    INTO v_count_b_failures
    FROM get_weekly_sensor_failure_duration(p_sensor_b_id, p_start_date) b
    WHERE b.failure_seconds IS NOT NULL
      AND b.failure_seconds >= v_failure_seconds_threshold;

    IF v_count_b_failures = 0 THEN
        RETURN 0.0;
    END IF;

    -- contar cuántos días fallaron A y B
    SELECT COUNT(*)
    INTO v_count_a_b_failures
    FROM get_weekly_sensor_failure_duration(p_sensor_a_id, p_start_date) a
    JOIN get_weekly_sensor_failure_duration(p_sensor_b_id, p_start_date) b
         ON a.date = b.date
    WHERE a.failure_seconds IS NOT NULL
      AND b.failure_seconds IS NOT NULL
      AND a.failure_seconds >= v_failure_seconds_threshold
      AND b.failure_seconds >= v_failure_seconds_threshold;

    RETURN v_count_a_b_failures::NUMERIC / v_count_b_failures::NUMERIC;
END;
$$ LANGUAGE plpgsql STABLE;
