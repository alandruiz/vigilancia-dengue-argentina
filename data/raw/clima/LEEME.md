# Datos meteorológicos del SMN

Los dos archivos de registros diarios pesan en conjunto unos 94 MB, por eso **no se versionan** en Git (ver `.gitignore`). Para ejecutar el notebook `02_clima_smn.ipynb` hay que descargarlos y guardarlos en esta carpeta con estos nombres:

| Archivo | Contenido |
|---|---|
| `datos_meteorologicos_1991_2020.xlsx` | Registros diarios 1991–2020 y hoja de estaciones |
| `datos_meteorologicos_desde_2021.lst` | Registros diarios desde 2021 (texto separado por tabulaciones) |
| `estaciones_meteorologicas_2021-2026.xlsx` | Estaciones con su provincia (sí se versiona, pesa 14 KB) |

**Fuente:** Servicio Meteorológico Nacional, [Descarga de datos](https://www.smn.gob.ar/descarga-de-datos).

Los notebooks 03, 04 y 05 no necesitan estos archivos: usan las tablas ya generadas en `data/processed/`, que sí están en el repositorio.
