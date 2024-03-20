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
helm repo index --url https://github.com/garrijuan/app-python-CICD/blob/main/HELM/apppython/charts/ .
```


delete chart of cluster
```sh
helm uninstall apppython
```


## ArgoCD intalacion en el cluster con chart

### instalar binario de argo cd
```sh
wget https://github.com/argoproj/argo-cd/releases/download/v2.10.4/argocd-linux-amd64
chmod +x argocd-linux-amd64
sudo mv argocd-linux-amd64 /usr/local/bin/argocd
argocd version
```

```sh
helm repo add argo https://argoproj.github.io/argo-helm
helm pull argo/argo-cd --version 5.8.2
helm list 
helm repo list # lista los chart descargados

# dentro ruta chart de argocd, esto parece que no funciona, lo despliego como arriba entonces
helm install argo-cd argo-cd/ \ 
  --namespace argocd \
  --create-namespace --wait \
  --set configs.credentialTemplates.github.url=https://github.com/garrijuan \
  --set configs.credentialTemplates.github.username=$(cat ~/.secrets/github/garrijuan/user) \
  --set configs.credentialTemplates.github.password=$(cat ~/.secrets/github/garrijuan/token)
```

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

argocd login localhost:8080
  
argocdpass
argocd account update-password
argocd repo add https://github.com/garrijuan/app-python-CICD.git

![alt text](/documentation/argocd-repo.png "ArgoCD-repository")

Creamos un proyecto de pruebas en el que solo se puedan crear aplicaciones en el namespace "testing" y con determinado repositorio de código
argocd proj create testing -d https://kubernetes.default.svc,testing -s https://github.com/garrijuan/app-python-CICD.git

Creamos el Namespace "testing" que sera el que usaremos para desplegar las aplicaciones
kubectl create ns testing

Ahora creamos nuestra primera aplicación de pruebas en el proyecto que hemos creado anteriormente
argocd app create apppython \
  --repo https://github.com/garrijuan/app-python-CICD.git \
  --revision main --path ./k8s \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace testing \
  --project testing

Ahora creamos otra app, pero esta vez con sincronización automática


  argocd app create helm-apppython \
  --repo https://github.com/garrijuan/app-python-CICD.git \
  --revision main --path ./HELM \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace testing \
  --sync-policy automated \
  --project testing

Ahora podemos relanzar la primera App y sincronizar desde la CLI
argocd app sync apppython

Si queremos saber el estatus de la App
argocd app get apppython

Ahora para eliminar las Apps
argocd app delete apppython