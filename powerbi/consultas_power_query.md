# Cómo conectar el dashboard de Power BI a los CSV

Los datos del proyecto son un corte histórico que no cambia, así que Power BI lee los CSV de esta carpeta y no se conecta a la base de datos. Cada archivo lleva el nombre de la tabla o la vista de `sql/dengue.db` (las genera el notebook `03_modelado_sql.ipynb`).

El tablero ya tiene las 14 tablas con sus medidas DAX y sus visuales. Solo hay que cambiar de dónde lee cada una, **sin borrarlas ni volver a importarlas**, para que las medidas y los gráficos sigan funcionando.

## 1. Crear el parámetro con la ruta del proyecto

1. En Power BI Desktop: **Inicio → Transformar datos**.
2. **Administrar parámetros → Nuevo parámetro**.
3. Nombre: `RutaProyecto`. Tipo: **Texto**. Valor actual: la carpeta donde está el repositorio, por ejemplo `E:\PROYECTOS PYTHON\vigilancia-dengue-argentina` (sin barra final).

Quien clone el repositorio solo tiene que cambiar este valor.

## 2. Reemplazar el código de cada consulta

Para cada una de las 14 consultas de la lista de la izquierda:

1. Selecciónela y abra **Vista → Editor avanzado**.
2. Borre todo lo que hay y pegue el código de esa tabla (más abajo).
3. **Listo**. Si Power BI pide permisos de archivo, elija **Editar permisos → Credenciales → Guardar**.

Cuando termine con las 14: **Cerrar y aplicar**.

## 3. Tipos de columna

- `latitud` y `longitud` de `vista_casos_por_provincia` **no se importan**: ya existen en el tablero como columnas calculadas (DAX). Si los CSV las trajeran, Power BI da error por nombre duplicado.
- `año` y `SE` de `vig_dengue` son **números enteros**: las medidas `Casos_2024` y `Variacion_%_Valida` los comparan con el número 2024.
- `año` de `vista_casos_por_anio` es **texto**, como en el tablero original (se usa como categoría del eje).
- `orden_edad` de `vista_casos_por_grupo_edad` se calcula en Power Query (ver su consulta).
- Los números llevan la cultura `"en-US"` en `Table.TransformColumnTypes`: los CSV usan punto decimal y, sin esto, Power BI en español puede leerlo mal.

## 4. Consultas

### `vig_dengue`

```powerquery
let
    Origen = Csv.Document(File.Contents(RutaProyecto & "\powerbi\vig_dengue.csv"), [Delimiter=",", Encoding=65001, QuoteStyle=QuoteStyle.Csv]),
    Encabezados = Table.PromoteHeaders(Origen, [PromoteAllScalars=true]),
    Tipos = Table.TransformColumnTypes(Encabezados, {{"id_dpto", type text}, {"departamento", type text}, {"id_prov", type text}, {"provincia", type text}, {"cant_habitantes", Int64.Type}, {"año", Int64.Type}, {"SE", Int64.Type}, {"SE_inicio", type datetime}, {"SE_fin", type datetime}, {"temp_media", type number}, {"precip_media", type number}, {"hum_rel", type number}, {"dias_pp_mas_1mm", type number}, {"evento", type text}, {"id_grupo_edad", type text}, {"grupo_edad", type text}, {"cant_casos", Int64.Type}, {"mes", Int64.Type}}, "en-US")
in
    Tipos
```

### `vista_casos_por_anio`

```powerquery
let
    Origen = Csv.Document(File.Contents(RutaProyecto & "\powerbi\vista_casos_por_anio.csv"), [Delimiter=",", Encoding=65001, QuoteStyle=QuoteStyle.Csv]),
    Encabezados = Table.PromoteHeaders(Origen, [PromoteAllScalars=true]),
    Tipos = Table.TransformColumnTypes(Encabezados, {{"año", type text}, {"casos_acumulados", Int64.Type}}, "en-US"),
    SinNulos = Table.SelectRows(Tipos, each ([año] <> null)),
    SinBlancos = Table.SelectRows(SinNulos, each not List.IsEmpty(List.RemoveMatchingItems(Record.FieldValues(_), {"", null})))
in
    SinBlancos
```

### `vista_casos_por_grupo_edad`

```powerquery
let
    Origen = Csv.Document(File.Contents(RutaProyecto & "\powerbi\vista_casos_por_grupo_edad.csv"), [Delimiter=",", Encoding=65001, QuoteStyle=QuoteStyle.Csv]),
    Encabezados = Table.PromoteHeaders(Origen, [PromoteAllScalars=true]),
    Tipos = Table.TransformColumnTypes(Encabezados, {{"grupo_edad", type text}, {"casos_acumulados", Int64.Type}}, "en-US"),
    SinNulos = Table.SelectRows(Tipos, each ([grupo_edad] <> null)),
    SinBlancos = Table.SelectRows(SinNulos, each not List.IsEmpty(List.RemoveMatchingItems(Record.FieldValues(_), {"", null}))),
    SinEdadSinEsp = Table.SelectRows(SinBlancos, each ([grupo_edad] <> "Edad sin esp")),
    Orden = {"Neonato (hasta 28 dias)", "Posneonato (de 29 a 365 dias)", "De 13 a 24 meses", "De 2 a 4 años", "De 5 a 9 años", "De 10 a 14 años", "De 15 a 19 años", "De 20 a 24 años", "De 25 a 34 años", "De 35 a 44 años", "De 45 a 64 años", "De 65 años o más"},
    ConOrden = Table.AddColumn(SinEdadSinEsp, "orden_edad", each List.PositionOf(Orden, [grupo_edad]) + 1, Int64.Type)
in
    ConOrden
```

Esta consulta agrega la columna `orden_edad` (1 = neonato … 12 = 65 años o más) y excluye los 933 casos sin edad. En el modelo, `grupo_edad` se ordena por `orden_edad` (**Herramientas de columna → Ordenar por columna**). El orden se define en Power Query y no con una columna DAX, porque una columna DAX que usa `grupo_edad` y a la vez ordena a `grupo_edad` produce una dependencia circular.

### `vista_casos_por_provincia`

```powerquery
let
    Origen = Csv.Document(File.Contents(RutaProyecto & "\powerbi\vista_casos_por_provincia.csv"), [Delimiter=",", Encoding=65001, QuoteStyle=QuoteStyle.Csv]),
    Encabezados = Table.PromoteHeaders(Origen, [PromoteAllScalars=true]),
    Tipos = Table.TransformColumnTypes(Encabezados, {{"provincia", type text}, {"casos_acumulados", Int64.Type}}, "en-US"),
    SinNulos = Table.SelectRows(Tipos, each ([provincia] <> null)),
    SinBlancos = Table.SelectRows(SinNulos, each not List.IsEmpty(List.RemoveMatchingItems(Record.FieldValues(_), {"", null})))
in
    SinBlancos
```

### `vista_clima_casos`

```powerquery
let
    Origen = Csv.Document(File.Contents(RutaProyecto & "\powerbi\vista_clima_casos.csv"), [Delimiter=",", Encoding=65001, QuoteStyle=QuoteStyle.Csv]),
    Encabezados = Table.PromoteHeaders(Origen, [PromoteAllScalars=true]),
    Tipos = Table.TransformColumnTypes(Encabezados, {{"provincia", type text}, {"año", Int64.Type}, {"SE", Int64.Type}, {"temp_media_prom", type number}, {"precip_media_prom", type number}, {"hum_rel_prom", type number}, {"casos_acumulados", Int64.Type}}, "en-US")
in
    Tipos
```

### `vista_estadisticas`

```powerquery
let
    Origen = Csv.Document(File.Contents(RutaProyecto & "\powerbi\vista_estadisticas.csv"), [Delimiter=",", Encoding=65001, QuoteStyle=QuoteStyle.Csv]),
    Encabezados = Table.PromoteHeaders(Origen, [PromoteAllScalars=true]),
    Tipos = Table.TransformColumnTypes(Encabezados, {{"min_casos", Int64.Type}, {"max_casos", Int64.Type}, {"promedio_casos", type number}, {"registros", Int64.Type}}, "en-US")
in
    Tipos
```

### `vista_incidencia_por_SE_provincia`

```powerquery
let
    Origen = Csv.Document(File.Contents(RutaProyecto & "\powerbi\vista_incidencia_por_SE_provincia.csv"), [Delimiter=",", Encoding=65001, QuoteStyle=QuoteStyle.Csv]),
    Encabezados = Table.PromoteHeaders(Origen, [PromoteAllScalars=true]),
    Tipos = Table.TransformColumnTypes(Encabezados, {{"SE", Int64.Type}, {"provincia", type text}, {"casos_acumulados", Int64.Type}, {"poblacion_provincial", Int64.Type}, {"incidencia_acum", type number}}, "en-US")
in
    Tipos
```

### `vista_incidencia_por_grupo_edad`

```powerquery
let
    Origen = Csv.Document(File.Contents(RutaProyecto & "\powerbi\vista_incidencia_por_grupo_edad.csv"), [Delimiter=",", Encoding=65001, QuoteStyle=QuoteStyle.Csv]),
    Encabezados = Table.PromoteHeaders(Origen, [PromoteAllScalars=true]),
    Tipos = Table.TransformColumnTypes(Encabezados, {{"grupo_edad", type text}, {"casos_acumulados", Int64.Type}, {"poblacion_total", Int64.Type}, {"incidencia_acum", type number}}, "en-US"),
    SinNulos = Table.SelectRows(Tipos, each ([grupo_edad] <> null)),
    SinBlancos = Table.SelectRows(SinNulos, each not List.IsEmpty(List.RemoveMatchingItems(Record.FieldValues(_), {"", null})))
in
    SinBlancos
```

### `vista_incidencia_por_provincia`

```powerquery
let
    Origen = Csv.Document(File.Contents(RutaProyecto & "\powerbi\vista_incidencia_por_provincia.csv"), [Delimiter=",", Encoding=65001, QuoteStyle=QuoteStyle.Csv]),
    Encabezados = Table.PromoteHeaders(Origen, [PromoteAllScalars=true]),
    Tipos = Table.TransformColumnTypes(Encabezados, {{"provincia", type text}, {"casos_acumulados", Int64.Type}, {"poblacion_provincial", Int64.Type}, {"incidencia_acum", type number}}, "en-US"),
    SinNulos = Table.SelectRows(Tipos, each ([provincia] <> null)),
    SinBlancos = Table.SelectRows(SinNulos, each not List.IsEmpty(List.RemoveMatchingItems(Record.FieldValues(_), {"", null})))
in
    SinBlancos
```

### `vista_incidencia_por_var_clim`

```powerquery
let
    Origen = Csv.Document(File.Contents(RutaProyecto & "\powerbi\vista_incidencia_por_var_clim.csv"), [Delimiter=",", Encoding=65001, QuoteStyle=QuoteStyle.Csv]),
    Encabezados = Table.PromoteHeaders(Origen, [PromoteAllScalars=true]),
    Tipos = Table.TransformColumnTypes(Encabezados, {{"SE", Int64.Type}, {"provincia", type text}, {"año", Int64.Type}, {"temp_media_prom", type number}, {"precip_media_prom", type number}, {"hum_rel_prom", type number}, {"dias_pp_mas_1mm_prom", type number}, {"casos_acumulados", Int64.Type}, {"poblacion_provincial", Int64.Type}, {"incidencia_acum", type number}}, "en-US"),
    SinNulos = Table.SelectRows(Tipos, each ([provincia] <> null)),
    SinBlancos = Table.SelectRows(SinNulos, each not List.IsEmpty(List.RemoveMatchingItems(Record.FieldValues(_), {"", null})))
in
    SinBlancos
```

### `vista_proporcion_casos_grupo_edad`

```powerquery
let
    Origen = Csv.Document(File.Contents(RutaProyecto & "\powerbi\vista_proporcion_casos_grupo_edad.csv"), [Delimiter=",", Encoding=65001, QuoteStyle=QuoteStyle.Csv]),
    Encabezados = Table.PromoteHeaders(Origen, [PromoteAllScalars=true]),
    Tipos = Table.TransformColumnTypes(Encabezados, {{"grupo_edad", type text}, {"casos_acumulados", Int64.Type}, {"proporcion", type number}}, "en-US")
in
    Tipos
```

### `vista_top_departamentos`

```powerquery
let
    Origen = Csv.Document(File.Contents(RutaProyecto & "\powerbi\vista_top_departamentos.csv"), [Delimiter=",", Encoding=65001, QuoteStyle=QuoteStyle.Csv]),
    Encabezados = Table.PromoteHeaders(Origen, [PromoteAllScalars=true]),
    Tipos = Table.TransformColumnTypes(Encabezados, {{"departamento", type text}, {"casos_acumulados", Int64.Type}}, "en-US")
in
    Tipos
```

### `vista_variacion_anual`

```powerquery
let
    Origen = Csv.Document(File.Contents(RutaProyecto & "\powerbi\vista_variacion_anual.csv"), [Delimiter=",", Encoding=65001, QuoteStyle=QuoteStyle.Csv]),
    Encabezados = Table.PromoteHeaders(Origen, [PromoteAllScalars=true]),
    Tipos = Table.TransformColumnTypes(Encabezados, {{"año", Int64.Type}, {"casos_acumulados", Int64.Type}, {"casos_previos", Int64.Type}, {"variacion", Int64.Type}}, "en-US")
in
    Tipos
```

### `vista_variacion_semanal`

```powerquery
let
    Origen = Csv.Document(File.Contents(RutaProyecto & "\powerbi\vista_variacion_semanal.csv"), [Delimiter=",", Encoding=65001, QuoteStyle=QuoteStyle.Csv]),
    Encabezados = Table.PromoteHeaders(Origen, [PromoteAllScalars=true]),
    Tipos = Table.TransformColumnTypes(Encabezados, {{"año", Int64.Type}, {"SE", Int64.Type}, {"provincia", type text}, {"casos_acumulados", Int64.Type}, {"casos_previos", Int64.Type}, {"variacion", Int64.Type}}, "en-US")
in
    Tipos
```

## 5. Medidas creadas para el dashboard

Además de las medidas originales del modelo, el dashboard usa estas, definidas en `vista_incidencia_por_var_clim`:

```dax
Incidencia por 100.000 =
DIVIDE(
    SUM('vista_incidencia_por_var_clim'[casos_acumulados]),
    SUMX(
        VALUES('vista_incidencia_por_var_clim'[provincia]),
        CALCULATE(MAX('vista_incidencia_por_var_clim'[poblacion_provincial]))
    )
) * 100000
```

```dax
Casos por provincia =
SUM('vista_incidencia_por_var_clim'[casos_acumulados])
```

Formato de ambas: personalizado `#,0`. La incidencia es casos totales sobre población, y no la suma de incidencias semanales, que carece de interpretación epidemiológica.
