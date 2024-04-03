# Usa una imagen base de Python
FROM python:3.9-slim

# Establece el directorio de trabajo en /app
WORKDIR /app

# Copia los archivos necesarios al directorio de trabajo
COPY app/main.py .
COPY app/requirements.txt .
COPY test/test_main.py ./test/

# Instala FastAPI y Uvicorn
RUN pip install fastapi uvicorn

# Expone el puerto 8000 en la imagen
EXPOSE 80

# Comando para ejecutar la aplicación cuando se inicie el contenedor
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]