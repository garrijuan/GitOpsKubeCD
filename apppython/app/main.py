from fastapi import FastAPI

# Crear una instancia de la aplicación FastAPI
app = FastAPI()

# Definir una ruta para la raíz de la aplicación
@app.get("/")
def read_root():
    return {"Hola": "Virulo 2"}
##comment 
