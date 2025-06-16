"""
Introducción a Streamlit para visualización rápida

Para ejecutar este modulo corre el comando python{version} -m streamlit run streamlit_viz.py.
En caso de que tu version de python sea la 3.10, este seria el comando:
python3.10 -m streamlit run streamlit_viz.py
"""

import streamlit as st
import seaborn as sns
import matplotlib.pyplot as plt
import pandas as pd

DATA_PATH: str = r"../data/planeta_salud_wellbeing_dataset.csv"
df = pd.read_csv(DATA_PATH)

st.title("Dashboard de Bienestar Urbano – Planeta Salud")

# Selector de ciudad
ciudad = st.selectbox("Seleccioná una ciudad", df["ciudad"].unique())
df_filtrado = df[df["ciudad"] == ciudad]

st.subheader(f"Nivel de estrés en {ciudad} por semana")
fig, ax = plt.subplots()
sns.lineplot(data=df_filtrado, x="semana", y="nivel_estres", marker="o", ax=ax)
st.pyplot(fig)

st.subheader("Relación entre espacios verdes y estrés")
fig2, ax2 = plt.subplots()
sns.scatterplot(data=df, x="espacios_verdes", y="nivel_estres", hue="ciudad", ax=ax2)
st.pyplot(fig2)