
# :rocket: GitOps :rocket: 


## Developer Microservice example to test the system

### Run app in local enviroment
```sh
uvicorn main:app --reload
```
### Run test
```sh
python3 test_main.py
python3 -m unittest appPython/test/test_main.py # From root directory
```
### generate dependencies file
```sh
pip freeze > requirements.txt
```
### Build image calling Dockerfile
```sh
docker build -t test_api_python .
docker run -d -p 80:80 test_api_python # Working Docker image
##test application
curl http://localhost:80
docker run -d -p 80:80 garrijuan/test_api_python:latest
```

## Minikube cluster 
```sh
minikube start
minikube addons enable ingress
kubectl apply -f k8s/
kubectl describe ingress

curl --location --request GET 'http://apppython'

#Ingress
# When you are using an Ingress and you do not specify a port in your Http request, by default port 80 will be assumed for HTTP requests. This is because Ingress is usually configured to redirect HTTP requests to port 80 for internal Kubernetes services.
```

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

change the api code to return a different string, and see how it synchronizes automatically.

**image-updater from argoCD has been used, for this we have deployed one more component in the argo installation, also add some annotation in the CRD(CD.yml)
to deploy this is necessary to use HELM, the short commit identifier is used as tag.

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
helm status apppython               
helm get values apppython           # Values of the current realease
```

you need a cluster running before use the previos command

```sh
 helm package apppython/ # pakage me chart in a .tgz
```
Updated the deploy
```sh
helm template mychart ./apppython # muestra todo el deploy
helm package apppython/ # pakage me chart in a .tgz
helm upgrade apppython ./apppython-0.1.0.tgz #deploy the new pakage chart
helm repo index --url https://github.com/garrijuan/app-python-CICD/blob/main/HELM/apppython/charts/ .
```
```sh
#helm repo add argo https://argoproj.github.io/argo-helm
#helm pull argo/argo-cd --version 5.8.2
helm list       # List all realease on a cluster
helm list --all # List all realease on a cluster with all status(UNINSTALLED;DEPLOYED, etc)
helm repo list  # List the Charts downloaded
```

delete chart of cluster
```sh
helm uninstall apppython
```


## Gitops on EKS

### step for the example
1.Deploy a cluster on EKS                                        :heavy_check_mark:

2.execute --> make install_argocd                                :heavy_check_mark:

3.install a ingress-nginx with previous HELM chats               :heavy_check_mark:

4.login in argocd                                                :heavy_check_mark:

5.test to deploy app with HELM chart apppython                   :heavy_check_mark:

6.test app is working                                            :heavy_check_mark:

7.delete apppython chart                                         :heavy_check_mark:

8.deploy app from path /app_python_cicd/apppython/k8s            :heavy_check_mark:

    --> kubectl apply -f CD.yml 

9.test app is working                                            :heavy_check_mark:

10.test change in the code and apply directly in the cluster     :heavy_check_mark:

```sh
#deploy nginx ingress in  the cluster to apply a ingress policy
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

kubectl create namespace ingress-nginx
helm install my-nginx-controller ingress-nginx/ingress-nginx --namespace ingress-nginx

kubectl get pods -n ingress-nginx

make install_argocd 
```

we apply the manifest deploy the app in Argocd.

![alt text](/documentation/LENS.png "ArgoCD-LENS")

Then we deploy the app in its first version and check on Argocd interface that the application has been deployed correctly.

![alt text](/documentation/argoEKS1.png "ArgoCD-EKS1")

we check in argocd that the application has been deployed correctly, now we will make a change in the code, for example, message returned = "Hola:Virulo2" . Argo should monitor the image repository, realize that there is a new image and deploy it automatically.

![alt text](/documentation/argoEKS2.png "ArgoCD-EKS1")

Now we make a change in the internal cluster infrastructure, change the number of replicas and check how argo notices this and deploys it automatically.

![alt text](/documentation/argoinfra.png "ArgoCD-infra")

In both cases we can see how it detects the commit at the top and how it deploys new pods every time we make a change.


Access to cluster throught the ALB(Load Balancer), the request to the microserver will be make ALB endpoint + specific path of microserver:
```sh
curl a7e5caf0b0ff24439a48331ac863e619-270330354.us-east-1.elb.amazonaws.com/api
```





