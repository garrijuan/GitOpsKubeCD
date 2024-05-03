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
##test application
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


## ArgoCD 
```sh
make install_argocd # if the cluster havent ArgoCD
kubectl port-forward svc/argocd-server -n argocd 8080:443 #expose argocd app in localhost port 8080
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo #Return the pass
argocd login localhost:8080
#if we want update the pass, fist login in Argo with the last command, afterwards update the pass with the following command.
#the pass must have a lengh between 8 and 32 characteres
argocd account update-password
```
To Access ArgoCD application:
http://localhost:8080
![alt text](/documentation/argoLogin.png "ArgoCD-login")
Enter user and pass:
user: admin
pass: get with following command
```sh
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```
![alt text](/documentation/argoCDinterface.png "ArgoCD-interface")
```sh
kubectl create ns staging # create this namespace to deploy on it
```
### Create the application on ArgoCD
```sh
#from path /app_python_cicd/apppython/k8s
kubectl apply -f CD.yml #this is a type of resource in kubernetes to deploy application.
```
when we deploy the application on ArgoCD it isnt syncronized by default, we have to manually do it  or enable the autosync

Add the github repository to ArgoCD to monitoring the changes
```sh
argocd repo add https://github.com/garrijuan/app-python-CICD.git
```
![alt text](/documentation/argocd-repo.png "ArgoCD-repository")
the following image is a example a applicaiton correctly syncronice
![alt text](/documentation/appargocd.png "ArgoCD-app-syncronice")
Now, we have syncronice the application and we can a get request and the application return the example message
![alt text](/documentation/argoCommit1.png "ArgoCD-app-syncroniceV1")
#cambio el codigo de la api para que me devuelva otro string diferente, y ver como se sincroniza automaticamente

**se ha usado image-updater de argoCD, para ello se ha desplegado un componente mas en la instalacion de argo, tambien añadir unos annotation en el CRD(CD.yml)
para desplegar esto es necesario usar HELM, se usa como tag el identificor corto del commit

CLI:
```sh
#Ahora podemos relanzar la primera App y sincronizar desde la CLI
argocd app sync apppython
#Si queremos saber el estatus de la App
argocd app get apppython
#Ahora para eliminar las Apps
argocd app delete apppython
```

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
helm repo index --url https://github.com/garrijuan/app-python-CICD/blob/main/HELM/apppython/charts/ .
```
```sh
#helm repo add argo https://argoproj.github.io/argo-helm
#helm pull argo/argo-cd --version 5.8.2
helm list 
helm repo list # lista los chart descargados
```

delete chart of cluster
```sh
helm uninstall apppython
```


## EKS
para usar ingress tengo que levantar un servicio de nginx con helm en ese cluster
```sh
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

kubectl create namespace ingress-nginx
helm install my-nginx-controller ingress-nginx/ingress-nginx
```sh

kubectl get pods -n ingress-nginx
