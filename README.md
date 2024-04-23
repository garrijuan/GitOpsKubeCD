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


## argoCD *****************************
```sh
make install_argocd # if the cluster havent ArgoCD
kubectl port-forward svc/argocd-server -n argocd 8080:443 #expose argocd app in localhost port 8080
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo #Return the pass
argocdpass   235-hC8ILfYMcYtg

argocd login localhost:8080

#si quiero actualizar la pass, primero me logeo(old pass), y despues cambio primero metiendo la pass antigua
#la pass tiene que tener entre 8 y 32 digitos
argocd account update-password

argocd repo add https://github.com/garrijuan/app-python-CICD.git
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

kubectl create ns testing

Ahora creamos nuestra primera aplicación de pruebas en el proyecto que hemos creado anteriormente

FORMA1
```sh
#from path /app_python_cicd/apppython/k8s
kubectl apply -f CD.yml
```
Al desplegar la app en ArgoCD por defecto no se sincroniza automaticamente, hay que hacerlo de forma manual o habilitar el autosincronize

añado el repo
argocd repo add https://github.com/garrijuan/app-python-CICD.git

![alt text](/documentation/argocd-repo.png "ArgoCD-repository")



![alt text](/documentation/appargocd.png "ArgoCD-app-syncronice")

![alt text](/documentation/argoCommit1.png "ArgoCD-app-syncroniceV1")

#cambio el codigo de la api para que me devuelva otro string diferente, y ver como se sincroniza automaticamente


FORMA2:(peta por permiso denegado)
```sh
#Creamos un proyecto de pruebas en el que solo se puedan crear aplicaciones en el namespace "testing" y con determinado repositorio de código
argocd proj create testing -d https://kubernetes.default.svc,testing -s https://github.com/garrijuan/app-python-CICD.git
#Creamos el Namespace "testing" que sera el que usaremos para desplegar las aplicaciones
kubectl create ns testing
#Ahora creamos la app
argocd app create apppython \
  --repo https://github.com/garrijuan/app-python-CICD.git \
  --revision main --path ./k8s \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace testing \
  #--sync-policy automated \
  --project testing
#Ahora creamos otra app, pero esta vez con sincronización automática
  argocd app create helm-apppython \
  --repo https://github.com/garrijuan/app-python-CICD.git \
  --revision main --path ./HELM \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace testing \
  --sync-policy automated \
  --project testing
#Ahora podemos relanzar la primera App y sincronizar desde la CLI
argocd app sync apppython
#Si queremos saber el estatus de la App
argocd app get apppython
#Ahora para eliminar las Apps
argocd app delete apppython
```
## ***********************

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


