"""
Introducción a Streamlit para visualización rápida

Para ejecutar este modulo corre el comando python{version} -m streamlit run app.py.
En caso de que tu version de python sea la 3.10, este seria el comando:
python3.10 -m streamlit run app.py
"""
import streamlit as st
from tabs import general_view, city_view
import pandas as pd

if __name__ == "__main__":
    st.set_page_config(page_title="Dashboard Bienestar Urbano", layout="wide")

    st.title("🌐 Monitoreo del Bienestar Urbano en América Latina")

    tab1, tab2 = st.tabs(["🔍 Visión General", "🏙️ Vista Ciudad"])

    PATH: str = r"../data/planeta_salud_wellbeing_dataset.csv"
    data: pd.DataFrame = pd.read_csv(PATH)
    
    with tab1:
        general_view.render(data)
    
    with tab2:
        city_view.render(data)