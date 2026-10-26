WITH filtros AS (
    SELECT
        DATE '2026-10-01' AS fecha_inicio,
        DATE '2026-10-31' AS fecha_fin
    FROM dual
)
SELECT
    v.punto_origen AS localidad,
    COUNT(s.id_solicitud) AS total_solicitudes
FROM Viaje v
JOIN Solicitud s ON v.id_viaje = s.id_viaje
CROSS JOIN filtros f
WHERE (f.fecha_inicio IS NULL OR v.fecha_hora_salida >= f.fecha_inicio)
  AND (f.fecha_fin IS NULL OR v.fecha_hora_salida < f.fecha_fin + 1)
GROUP BY
    v.punto_origen
ORDER BY
    total_solicitudes DESC;









WITH filtros AS (
    SELECT
        DATE '2026-10-01' AS fecha_inicio,
        DATE '2026-10-31' AS fecha_fin
    FROM dual
)
SELECT
    v.punto_origen AS localidad,
    SUM(v.costo) AS ingresos_estimados
FROM Viaje v
JOIN Solicitud s
    ON v.id_viaje = s.id_viaje
CROSS JOIN filtros f
WHERE v.estado = 'COMPLETADO'
  AND s.estado_solicitud = 'ACEPTADA'
  AND (f.fecha_inicio IS NULL
       OR v.fecha_hora_salida >= f.fecha_inicio)
  AND (f.fecha_fin IS NULL
       OR v.fecha_hora_salida < f.fecha_fin + 1)
GROUP BY v.punto_origen
ORDER BY ingresos_estimados DESC;






WITH filtros AS (
    SELECT
        CAST(NULL AS VARCHAR2(20)) AS conductor,
        CAST(NULL AS VARCHAR2(100)) AS localidad,
        DATE '2026-10-01' AS fecha_inicio,
        DATE '2026-10-31' AS fecha_fin
    FROM dual
)
SELECT
    v.id_conductor,
    v.punto_origen AS localidad,
    TRUNC(v.fecha_hora_salida) AS fecha,
    COUNT(*) AS total_viajes
FROM Viaje v
CROSS JOIN filtros f
WHERE v.estado = 'COMPLETADO'
  AND (f.conductor IS NULL OR v.id_conductor = f.conductor)
  AND (f.localidad IS NULL OR v.punto_origen = f.localidad)
  AND (f.fecha_inicio IS NULL OR v.fecha_hora_salida >= f.fecha_inicio)
  AND (f.fecha_fin IS NULL OR v.fecha_hora_salida < f.fecha_fin + 1)
GROUP BY
    v.id_conductor,
    v.punto_origen,
    TRUNC(v.fecha_hora_salida)
ORDER BY
    v.id_conductor,
    fecha;