# Vigilancia Epidemiológica del Dengue en Argentina

## Descripción del proyecto
Este proyecto aborda el análisis y modelado de la incidencia del dengue en Argentina, integrando datos epidemiológicos y variables climáticas con el objetivo de explorar patrones temporales y desarrollar un modelo predictivo que contribuya a la vigilancia epidemiológica.

El trabajo combina un enfoque científico (formulación de hipótesis, interpretación de resultados) con técnicas de análisis de datos y machine learning, aplicadas a un problema real de salud pública.

---

## Objetivos
- Analizar la evolución temporal de la incidencia del dengue.
- Explorar la relación entre variables epidemiológicas y climáticas.
- Realizar un análisis exploratorio de datos (EDA) orientado a la toma de decisiones.
- Desarrollar y evaluar modelos predictivos para estimar la incidencia de dengue.
- Identificar las variables más influyentes en la predicción.

---

## Dataset
- **Fuente:** Datos públicos de vigilancia epidemiológica y variables climáticas.
- **Cobertura temporal:** Múltiples períodos anuales.
- **Tipo de datos:** Series temporales epidemiológicas y climáticas agregadas.

*(Los datos fueron preprocesados y transformados para su uso analítico y predictivo.)*

---

## Metodología
1. **Limpieza y preprocesamiento de datos**
   - Tratamiento de valores faltantes
   - Conversión de variables temporales
   - Unificación de fuentes

2. **Feature Engineering**
   - Creación de variables rezagadas (lags)
   - Promedios móviles
   - Transformaciones temporales relevantes para epidemiología

3. **Análisis Exploratorio de Datos (EDA)**
   - Visualización de tendencias temporales
   - Análisis de correlaciones
   - Identificación de patrones relevantes

4. **Modelado Predictivo**
   - Modelo base con Random Forest
   - Ajuste de hiperparámetros (GridSearch / RandomizedSearch)
   - Comparación de desempeño entre modelo base y modelo ajustado

5. **Evaluación**
   - Métricas de error para regresión
   - Análisis de importancia de variables
   - Discusión de limitaciones del modelo

---

## Modelos utilizados
- **Random Forest Regressor**
  - Modelo base
  - Modelo ajustado con tuning de hiperparámetros

---

## Resultados principales
- El modelo ajustado mejora el desempeño respecto al modelo base.
- Las variables más influyentes incluyen la incidencia previa de dengue y factores climáticos.
- El enfoque demuestra el potencial del machine learning como herramienta complementaria para la vigilancia epidemiológica, aunque no se plantea como sistema operativo sin validación adicional.

---

## Tecnologías y herramientas
- Python
- Pandas
- NumPy
- Matplotlib
- Seaborn
- Scikit-learn
- Jupyter Notebook

---

## Limitaciones y próximos pasos
- Incorporar mayor granularidad espacial.
- Evaluar modelos específicos para series temporales.
- Validar el modelo con datos más recientes.
- Analizar su potencial integración en sistemas de alerta temprana.

---

## ⚠️ Nota
Este proyecto tiene fines educativos y exploratorios.
No reemplaza sistemas oficiales de vigilancia epidemiológica.

---

## 👤 Autor
**Alan Ruiz Diez**  
Biólogo | Data Analyst Jr. / Data Scientist Jr.  
[LinkedIn]  
[GitHub]
