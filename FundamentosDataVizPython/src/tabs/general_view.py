# tabs/general_view.py

from pandas import DataFrame
import plotly.express as px
import streamlit as st

def render(df: DataFrame):
    st.title("🌎 Visión General del Bienestar Urbano")

    st.subheader("🧠 Santiago es la ciudad con el promedio de estrés mas elevado.")
    estres_prom = df.groupby("ciudad")["nivel_estres"].mean().sort_values(ascending=False).reset_index()

    fig1 = px.bar(
        estres_prom,
        x="nivel_estres",
        y="ciudad",
        orientation="h",
        title="Ciudades con mayor nivel promedio de estrés",
        color="nivel_estres",
        color_continuous_scale="Reds"
    )
    st.plotly_chart(fig1, use_container_width=True)

    st.subheader("📈 Buenos Aires es la ciudad en la cual el estrés por semana siempre crece.")
    df_line = df.groupby(["ciudad", "semana"])["nivel_estres"].mean().reset_index()

    fig2 = px.line(
        df_line,
        x="semana",
        y="nivel_estres",
        color="ciudad",
        markers=True,
        title="Tendencia semanal de estrés urbano por ciudad"
    )
    st.plotly_chart(fig2, use_container_width=True)

    st.subheader("🌳 Santiago es la ciudad con el promedio de estrés mas elevado teniendo un area de espacios verdes moderada.")
    fig3 = px.scatter(
        df,
        x="espacios_verdes",
        y="nivel_estres",
        color="ciudad",
        hover_data=["semana"],
        title="Espacios verdes vs. nivel de estrés",
        opacity=0.7
    )
    st.plotly_chart(fig3, use_container_width=True)
