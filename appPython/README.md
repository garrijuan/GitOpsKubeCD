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

