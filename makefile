# Variables
IMAGE_NAME := myapp
IMAGE_TAG := latest
APP_NAME := myapp
MINIKUBE_PROFILE := minikube-cluster

# Comandos
start_cluster:
	minikube start --profile=$(MINIKUBE_PROFILE) 

start_cluster_complete:
	minikube start --profile=$(MINIKUBE_PROFILE) 
	minikube addons enable ingress --profile=$(MINIKUBE_PROFILE)
	kubectl create namespace argocd
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj-labs/argocd-image-updater/stable/manifests/install.yaml 
	kubectl create namespace staging
	@echo "Cluster created + Ingress + ArgoCD"

delete_cluster:
	minikube stop --profile=$(MINIKUBE_PROFILE)
	minikube delete --profile=$(MINIKUBE_PROFILE)
	@echo "Cluster deleted"

enable_ingress:
	minikube addons enable ingress --profile=$(MINIKUBE_PROFILE)

# Install ArgoCD
install_argocd:
	kubectl create namespace argocd
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj-labs/argocd-image-updater/stable/manifests/install.yaml 

# Delete ArgoCD
delete_argocd:
	kubectl delete -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
	kubectl delete -n argocd -f https://raw.githubusercontent.com/argoproj-labs/argocd-image-updater/stable/manifests/install.yaml 
	kubectl delete namespace argocd
	@echo "Delete argocd namespace manually when objects are finalized"


#build-image:
#	docker build -t $(IMAGE_NAME):$(IMAGE_TAG) .

#load-image:
#	minikube image load $(IMAGE_NAME):$(IMAGE_TAG) --profile=$(MINIKUBE_PROFILE)

#deploy-app:
#	kubectl apply -f deployment.yaml

#expose-app:
#	kubectl expose deployment $(APP_NAME) --type=NodePort --port=80

#apply-ingress:
#	kubectl apply -f ingress.yaml

# Tareas
start: start_cluster enable_ingress install_argocd

#deploy: build-image load-image deploy-app expose-app apply-ingress
