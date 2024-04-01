## Run app in local envoroment
```sh
uvicorn main:app --reload
```

## generate dependencies file
```sh
pip freeze > requirements.txt
```

## Build image calling Dockerfile
```sh
docker build -t test_api_python .

docker run -d -p 80:80 test_api_python #levantar imagen  docker

curl http://localhost:80

docker run -d -p 80:80 garrijuan/test_api_python:latest
```
