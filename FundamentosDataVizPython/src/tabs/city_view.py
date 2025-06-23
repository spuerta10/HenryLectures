import pandas as pd
import plotly.express as px
import streamlit as st

def render(df: pd.DataFrame):
    st.title("🏙️ Análisis Detallado por Ciudad")

    ciudades = df["ciudad"].unique()
    ciudad_seleccionada = st.selectbox("Selecciona una ciudad para explorar", ciudades)

    df_ciudad = df[df["ciudad"] == ciudad_seleccionada]

    st.subheader(f"📊 Indicadores clave para {ciudad_seleccionada}")
    col1, col2, col3, col4 = st.columns(4)

    with col1:
        estres_prom = df_ciudad["nivel_estres"].mean()
        st.metric("Nivel de Estrés Promedio", f"{estres_prom:.2f}")

    with col2:
        verdes_prom = df_ciudad["espacios_verdes"].mean()
        st.metric("Espacios Verdes (m²/hab)", f"{verdes_prom:.1f}")

    with col3:
        actividad = df_ciudad["actividad_fisica_semanal_horas"].mean()
        st.metric("Actividad Física (hrs/sem)", f"{actividad:.1f}")

    with col4:
        transporte = df_ciudad["satisfaccion_transporte"].mean()
        st.metric("Satisfacción Transporte", f"{transporte:.1f}/10")

    st.subheader("📈 Evolución semanal del nivel de estrés")
    fig_line = px.line(
        df_ciudad,
        x="semana",
        y="nivel_estres",
        markers=True,
        title=f"Nivel de estrés en {ciudad_seleccionada}",
    )
    st.plotly_chart(fig_line, use_container_width=True)

    st.subheader("🌳 Relación entre Espacios Verdes y Estrés (Todas las ciudades)")
    fig_scatter = px.scatter(
        df,
        x="espacios_verdes",
        y="nivel_estres",
        color="ciudad",
        title="Espacios verdes vs. nivel de estrés",
        hover_data=["ciudad", "semana"],
        opacity=0.6
    )
    fig_scatter.add_scatter(
        x=df_ciudad["espacios_verdes"],
        y=df_ciudad["nivel_estres"],
        mode="markers",
        name=f"{ciudad_seleccionada} (destacada)",
        marker=dict(color="black", size=10, line=dict(width=2, color="white"))
    )
    st.plotly_chart(fig_scatter, use_container_width=True)

    st.subheader("🛡️ Seguridad Percibida por Semana")
    if "seguridad_percibida" in df.columns:
        fig_seguridad = px.line(
            df_ciudad,
            x="semana",
            y="seguridad_percibida",
            markers=True,
            title=f"Seguridad percibida en {ciudad_seleccionada}",
        )
        fig_seguridad.update_layout(yaxis_title="Nivel de Seguridad (1 a 10)")
        st.plotly_chart(fig_seguridad, use_container_width=True)
    else:
        st.warning("⚠️ La columna 'seguridad_percibida' no está presente en el dataset.")

    st.subheader("💨 Calidad del Aire por Semana")
    if "calidad_aire" in df.columns:
        fig_aire = px.line(
            df_ciudad,
            x="semana",
            y="calidad_aire",
            markers=True,
            title=f"Calidad del aire en {ciudad_seleccionada}",
        )
        fig_aire.update_layout(yaxis_title="Calidad del Aire (AQI o similar)")
        st.plotly_chart(fig_aire, use_container_width=True)
    else:
        st.warning("⚠️ La columna 'calidad_aire' no está presente en el dataset.")

    st.info("Estos indicadores permiten explorar condiciones particulares de cada ciudad y cómo evolucionan en el tiempo.")
