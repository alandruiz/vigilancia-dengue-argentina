# **Vigilancia Epidemiológica del Dengue en Argentina**
**Análisis de datos end-to-end: Python + SQL + Power BI**

## **Indice**

- [**Vigilancia Epidemiológica del Dengue en Argentina**](#vigilancia-epidemiológica-del-dengue-en-argentina)
  - [**Indice**](#indice)
  - [**Descripcion del proyecto**](#descripcion-del-proyecto)
  - [**Objetivos**](#objetivos)
  - [**Dataset**](#dataset)
  - [**Metodologia**](#metodologia)
  - [**Capa SQL para analisis estructurado**](#capa-sql-para-analisis-estructurado)
  - [**Resultados principales**](#resultados-principales)
  - [**Dashboard (Power BI)**](#dashboard-power-bi)
  - [**Insights clave**](#insights-clave)
  - [**Limitaciones**](#limitaciones)
  - [**Valor agregado del proyecto**](#valor-agregado-del-proyecto)
  - [**Tecnologias utilizadas**](#tecnologias-utilizadas)
  - [**Proximos pasos**](#proximos-pasos)
  - [**Autor**](#autor)

## **Descripcion del proyecto**

Este proyecto desarrolla un análisis integral del dengue en Argentina, combinando datos epidemiológicos y variables climáticas para identificar patrones, relaciones y tendencias relevantes.

El enfoque implementa un pipeline completo de datos (end-to-end) que abarca:

Limpieza y transformación de datos (Python)
Modelado estructurado (SQLite)
Visualización e interpretación (Power BI)

Se integran herramientas de Data Science con criterios epidemiológicos para generar insights aplicables a la salud pública.

## **Objetivos**

- Analizar la evolución temporal del dengue en Argentina
- Identificar patrones espaciales a nivel provincial
- Evaluar la relación entre variables climáticas e incidencia
- Construir modelos predictivos
- Diseñar un dashboard interactivo para análisis en BI

## **Dataset**

- Fuente: Datos públicos de vigilancia epidemiológica y registros climáticos.
- Cobertura: Múltiples años y semanas epidemiológicas.
- Granularidad: Provincia, departamento, semana epidemiológica y grupo etario.
- Variables clave:
   - Casos confirmados
   - Población
   - Temperatura media
   - Precipitación
   - Humedad relativa
   - Días de lluvia

Los datos fueron limpiados, transformados y estructurados para su uso analítico.

## **Metodologia**

1) **Limpieza y preprocesamiento (Python)**

- Tratamiento de valores faltantes
- Normalización de variables
- Transformación de fechas

2) **Feature Engineering**

- Variables rezagadas (lags)
- Transformaciones logarítmicas
- Cálculo de incidencia (por 100.000 habitantes)
- Métricas acumuladas

3) **Análisis Exploratorio (EDA)**

- Tendencias temporales
- Distribución geográfica
- Análisis por grupo etario
- Relación clima–casos

4) **Modelado Predictivo**

- Random Forest Regressor
- Optimización de hiperparámetros
- Evaluación de desempeño

5) **Modelado de datos (SQLite)**

Se implementó una base de datos relacional con vistas analíticas para:

- Estandarizar métricas epidemiológicas
- Permitir consultas reproducibles
- Separar lógica analítica del código Python
- Integrar con herramientas BI

6) **Visualización (Power BI)**

Se desarrolló un dashboard interactivo dividido en 4 páginas:

- Overview epidemiológico
- Análisis demográfico
- Factores ambientales
- Insights y conclusiones

## **Capa SQL para analisis estructurado**

Las vistas fueron diseñadas para facilitar análisis en BI.

Incluyen:

- *Análisis temporal*
  - Casos acumulados por año
  - Variación interanual (LAG)
  - Evolución semanal
- Análisis espacial
  - Casos por provincia
  - Ranking de departamentos
- Análisis demográfico
  - Distribución por grupo etario
  - Proporción de casos

*Nota: No se calcula incidencia por edad por falta de población desagregada.*

- *Incidencia epidemiológica*

Incidencia = Población / Casos​ × 100.000

Se utiliza MAX(población) para evitar duplicaciones.

- Integración clima–salud
  - Promedios climáticos
  - Relación con incidencia
  - Datos preparados para análisis multivariable

## **Resultados principales**

- Fuerte variabilidad interanual, con picos epidémicos marcados
- Diferencias significativas entre provincias
- Mayor concentración de casos en adultos (25–64 años)
- Correlación positiva moderada entre temperatura e incidencia (r ≈ 0.45)
- Baja correlación con humedad y precipitación

## **Dashboard (Power BI)**

El dashboard permite explorar:

- Evolución temporal de casos
- Distribución geográfica
- Análisis demográfico
- Relación entre variables climáticas

## **Insights clave**

- El dengue presenta comportamiento epidémico con fuerte variabilidad
- La temperatura es el factor ambiental más relevante
- La incidencia se concentra en regiones cálidas
- Los adultos representan el grupo más afectado

## **Limitaciones**

- Datos agregados (no implican causalidad)
- Falta de variables socioeconómicas
- Posible incompletitud en años recientes
- No se incluye población por grupo etario

## **Valor agregado del proyecto**

Este proyecto demuestra:

- Pipeline end-to-end de datos
- Integración Python + SQL + Power BI
- Aplicación de conceptos epidemiológicos
- Uso de funciones de ventana en SQL
- Construcción de dashboards analíticos
- Enfoque científico en Data Science

## **Tecnologias utilizadas**

- Python
- Pandas
- NumPy
- Matplotlib / Seaborn
- Scikit-learn
- SQLite
- Power BI
- Jupyter Notebook

## **Proximos pasos**

- Incorporar población por grupo etario
- Modelos de series temporales (ARIMA / Prophet)
- Modelos predictivos más avanzados
- Automatización del pipeline
- Deploy del dashboard


## **Autor**
**Alan Ruiz Diez**  
Biólogo | Data Analyst Jr. / Data Scientist Jr.  
[LinkedIn]  
[GitHub]




