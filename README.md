puntos:
app basica API REST con Python(FASTAPI)
test basico Responde 200 con pytest
worflow github actions commit con test ok
dockerfile para generar imagen docker y correr en local
workflow github action automatizar generacion imagen y repositado en dockerhub
comprobar que levanta imagen desde dockerhub y App Working


## Run app in local envoroment
```sh
uvicorn main:app --reload
```

## Run test
```sh
python3 test_main.py

python3 -m unittest appPython/test/test_main.py #desde el raiz
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

## minikube cluster 
```sh
minikube start
minikube addons enable ingress
kubectl apply -f k8s/
kubectl describe ingress


curl --location --request GET 'http://apppython'
```

Ingress
si estás utilizando un Ingress y no especificas un puerto en tu solicitud curl, por defecto se asumirá el puerto 80 para las solicitudes HTTP. Esto se debe a que el Ingress suele estar configurado para redirigir las solicitudes HTTP al puerto 80 de los servicios internos de Kubernetes


## argoCD
https://medium.com/@mehmetodabashi/installing-argocd-on-minikube-and-deploying-a-test-application-caa68ec55fbf
```sh
kubectl create ns argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.5.8/manifests/install.yaml
kubectl get all -n argocd
kubectl port-forward svc/argocd-server -n argocd 8080:443 #expose argocd app in localhost port 8080
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```
http://localhost:8080
![alt text](/documentation/argoLogin.png "ArgoCD-login")
```
Enter user and pass:
user: admin
pass: get with following command
```
`kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo`

![alt text](/documentation/argoCDinterface.png "ArgoCD-interface")


## HELM
```sh 
helm create apppython
```

the previous command create a folder with different files, you should update deployment, service, ingress, notes... with your preferences and updated the values in the values.yml file

```sh
helm install apppython ./apppython
```

you need a cluster running before use the previos command

```sh
 helm package apppython/ # pakage me chart in a .tgz
```
Updated the deploy
```sh
helm template mychart ./apppython # muestra todo el deploy
helm package apppython/ # pakage  chart 
helm upgrade apppython ./apppython-0.1.0.tgz #deploy the new pakage chart
```
