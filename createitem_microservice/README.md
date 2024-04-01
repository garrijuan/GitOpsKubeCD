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
docker build -t createitem .
docker tag createitem ${{ secrets.DOCKER_USERNAME }}/createitem:latest
docker push ${{ secrets.DOCKER_USERNAME }}/createitem:latest

docker run -d -p 8000:8000 createitem #levantar imagen  docker

curl http://localhost:8000

docker run -d -p 8000:8000 garrijuan/createitem:latest
```


levantar mysql y asignar datos a las variables de entorno
