puntos:
app basica API REST con Python(FASTAPI)
test basico Responde 200 con pytest
worflow github actions commit con test ok
dockerfile para generar imagen docker y correr en local
workflow github action automatizar generacion imagen y repositado en dockerhub
comprobar que levanta imagen desde dockerhub y App Working


## correr app en local
```sh
uvicorn main:app --reload
```

## correr test 
```sh
python3 test_main.py

python3 -m unittest appPython/test/test_main.py #desde el raiz
```

## generar archivo de dependencias
```sh
pip freeze > requirements.txt
```

## construir imagen llamando al dockerfile
```sh
docker build -t test_api_python .

docker run -d -p 80:80 test_api_python #levantar imagen  docker

curl http://localhost:80

docker run -d -p 80:80 garrijuan/test_api_python:latest
```

## cluster minikube
```sh
minikube start
kubectl apply -f k8s/
minikube addons enable ingress
```

curl --location --request GET 'http://apppython'



Ingress
si estás utilizando un Ingress y no especificas un puerto en tu solicitud curl, por defecto se asumirá el puerto 80 para las solicitudes HTTP. Esto se debe a que el Ingress suele estar configurado para redirigir las solicitudes HTTP al puerto 80 de los servicios internos de Kubernetes
