#!/bin/bash

echo "Instalar Docker"

sudo apt install apt-transport-https  ca-certificates curl gnupg2 software-properties-common -y
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian/ $(lsb_release -cs) stable"
sudo apt update
sudo apt upgrade -y
sudo apt install docker-ce docker-ce-cli containerd.io -y
sudo systemctl start docker
sudo systemctl enable docker

echo "Instalar Kubectl"

grep -rhE ^deb /etc/apt/sources.list* | grep "cloud-sdk"
sudo apt-get update
sudo apt-get install -y kubectl
sudo apt-get install -y google-cloud-sdk-gke-gcloud-auth-plugine-gcloud-auth-plugin 

echo "Acessar no DockerHub"

sudo docker login

echo "Criando as imagens..."

sudo docker build -t rcjunior/projeto-backend:1.0 backend/.
sudo docker build -t rcjunior/projeto-database:1.0 database/.

echo "Realizando push das imagens..."

sudo docker push rcjunior/projeto-backend:1.0
sudo docker push rcjunior/projeto-database:1.0

echo "Criando serviços no cluster kubernets..."

sudo kubectl apply -f ./services.yml

echo "Criando os deployments..."

sudo kubectl apply -f ./deployment.yml