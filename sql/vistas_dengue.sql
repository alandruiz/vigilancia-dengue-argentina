-- Vistas analíticas del proyecto de vigilancia del dengue (generado por 03_modelado_sql.ipynb)

DROP VIEW IF EXISTS vista_casos_por_anio;
CREATE VIEW vista_casos_por_anio AS
SELECT "año", SUM(cant_casos) AS casos_acumulados
FROM vig_dengue
GROUP BY "año"
ORDER BY "año";

DROP VIEW IF EXISTS vista_casos_por_provincia;
CREATE VIEW vista_casos_por_provincia AS
SELECT provincia, SUM(cant_casos) AS casos_acumulados
FROM vig_dengue
WHERE provincia IS NOT NULL
GROUP BY provincia
ORDER BY casos_acumulados DESC;

DROP VIEW IF EXISTS vista_casos_por_grupo_edad;
CREATE VIEW vista_casos_por_grupo_edad AS
SELECT grupo_edad, SUM(cant_casos) AS casos_acumulados
FROM vig_dengue
GROUP BY grupo_edad
ORDER BY casos_acumulados;

DROP VIEW IF EXISTS vista_proporcion_casos_grupo_edad;
CREATE VIEW vista_proporcion_casos_grupo_edad AS
SELECT grupo_edad,
       SUM(cant_casos) AS casos_acumulados,
       SUM(cant_casos) * 100.0 / (SELECT SUM(cant_casos) FROM vig_dengue) AS proporcion
FROM vig_dengue
GROUP BY grupo_edad
ORDER BY casos_acumulados DESC;

DROP VIEW IF EXISTS vista_top_departamentos;
CREATE VIEW vista_top_departamentos AS
-- El nombre del departamento se repite entre provincias ("capital" existe en 11), por eso se muestra junto a la provincia
SELECT departamento || ' (' || provincia || ')' AS departamento, SUM(cant_casos) AS casos_acumulados
FROM vig_dengue
WHERE departamento IS NOT NULL AND provincia IS NOT NULL
GROUP BY provincia, departamento
ORDER BY casos_acumulados DESC
LIMIT 10;

DROP VIEW IF EXISTS vista_estadisticas;
CREATE VIEW vista_estadisticas AS
SELECT MIN(cant_casos) AS min_casos, MAX(cant_casos) AS max_casos,
       AVG(cant_casos) AS promedio_casos, COUNT(*) AS registros
FROM vig_dengue;

DROP VIEW IF EXISTS vista_incidencia_por_provincia;
CREATE VIEW vista_incidencia_por_provincia AS
-- Incidencia acumulada del período 2018-2025: casos totales por 100.000 habitantes de la provincia
SELECT provincia,
       SUM(cant_casos) AS casos_acumulados,
       MAX(cant_habitantes) AS poblacion_provincial,
       SUM(cant_casos) * 100000.0 / NULLIF(MAX(cant_habitantes), 0) AS incidencia_acum
FROM vig_dengue
WHERE provincia IS NOT NULL
GROUP BY provincia
ORDER BY incidencia_acum DESC;

DROP VIEW IF EXISTS vista_incidencia_por_SE_provincia;
CREATE VIEW vista_incidencia_por_SE_provincia AS
-- Casos acumulados en cada semana epidemiológica (sumando todos los años) por 100.000 habitantes
SELECT SE, provincia,
       SUM(cant_casos) AS casos_acumulados,
       MAX(cant_habitantes) AS poblacion_provincial,
       SUM(cant_casos) * 100000.0 / NULLIF(MAX(cant_habitantes), 0) AS incidencia_acum
FROM vig_dengue
WHERE provincia IS NOT NULL
GROUP BY SE, provincia
ORDER BY provincia, CAST(SE AS INTEGER);

DROP VIEW IF EXISTS vista_incidencia_por_grupo_edad;
CREATE VIEW vista_incidencia_por_grupo_edad AS
-- OJO: no es incidencia específica por edad, porque la fuente no trae población por grupo etario.
-- Relaciona los casos de cada grupo con la población total de las provincias con casos.
SELECT grupo_edad,
       SUM(cant_casos) AS casos_acumulados,
       (SELECT SUM(habitantes) FROM (SELECT MAX(cant_habitantes) AS habitantes FROM vig_dengue
                                     WHERE provincia IS NOT NULL GROUP BY provincia)) AS poblacion_total,
       SUM(cant_casos) * 100000.0 /
           (SELECT SUM(habitantes) FROM (SELECT MAX(cant_habitantes) AS habitantes FROM vig_dengue
                                         WHERE provincia IS NOT NULL GROUP BY provincia)) AS incidencia_acum
FROM vig_dengue
GROUP BY grupo_edad;

DROP VIEW IF EXISTS vista_variacion_anual;
CREATE VIEW vista_variacion_anual AS
WITH casos_anuales AS (
    SELECT "año", SUM(cant_casos) AS casos_acumulados FROM vig_dengue GROUP BY "año"
)
SELECT "año", casos_acumulados,
       LAG(casos_acumulados) OVER (ORDER BY "año") AS casos_previos,
       casos_acumulados - LAG(casos_acumulados) OVER (ORDER BY "año") AS variacion
FROM casos_anuales
ORDER BY "año";

DROP VIEW IF EXISTS vista_variacion_semanal;
CREATE VIEW vista_variacion_semanal AS
SELECT "año", SE, provincia,
       cant_casos AS casos_acumulados,
       LAG(cant_casos) OVER (PARTITION BY provincia, "año" ORDER BY SE) AS casos_previos,
       cant_casos - LAG(cant_casos) OVER (PARTITION BY provincia, "año" ORDER BY SE) AS variacion
FROM panel_provincia_semana
ORDER BY provincia, "año", SE;

DROP VIEW IF EXISTS vista_clima_casos;
CREATE VIEW vista_clima_casos AS
-- Clima semanal real de la provincia (promedio de sus estaciones SMN) junto a los casos de la misma semana
SELECT provincia, "año", SE,
       temp_media AS temp_media_prom,
       precip_sem AS precip_media_prom,
       hum_rel AS hum_rel_prom,
       cant_casos AS casos_acumulados
FROM panel_provincia_semana
ORDER BY provincia, "año", SE;

DROP VIEW IF EXISTS vista_incidencia_por_var_clim;
CREATE VIEW vista_incidencia_por_var_clim AS
-- Una fila por provincia y semana (incluye semanas sin casos): es la tabla de base para relacionar clima e incidencia
SELECT SE, provincia, "año",
       temp_media AS temp_media_prom,
       precip_sem AS precip_media_prom,
       hum_rel AS hum_rel_prom,
       dias_lluvia_sem AS dias_pp_mas_1mm_prom,
       cant_casos AS casos_acumulados,
       cant_habitantes AS poblacion_provincial,
       incidencia_100k AS incidencia_acum
FROM panel_provincia_semana;
