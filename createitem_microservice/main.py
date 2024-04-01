import os
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import mysql.connector

# Modelo Pydantic para la entrada de datos
class Item(BaseModel):
    name: str
    description: str

app = FastAPI()

# Obtiene las credenciales de MySQL de las variables de entorno, definir estas variables de entorno en tu clúster de Kubernetes antes de desplegar el microservicio.
db_config = {
    'user': os.getenv('MYSQL_USER'),
    'password': os.getenv('MYSQL_PASSWORD'),
    'host': os.getenv('MYSQL_HOST'),  # Nombre del servicio de MySQL en Kubernetes
    'database': os.getenv('MYSQL_DATABASE')
}

# Función para guardar el ítem en la base de datos
def save_item_to_db(item: Item):
    connection = mysql.connector.connect(**db_config)
    cursor = connection.cursor()
    query = "INSERT INTO items (name, description) VALUES (%s, %s)"
    data = (item.name, item.description)
    cursor.execute(query, data)
    connection.commit()
    cursor.close()
    connection.close()

# Endpoint para la creación de un nuevo ítem
@app.post("/itemcreate/")
async def create_item(item: Item):
    save_item_to_db(item)
    return {"message": "Item created successfully"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)