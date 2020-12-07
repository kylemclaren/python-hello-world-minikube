#!/bin/bash

PREFIX="/usr/local/bin"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Attempting to install minikube and assorted tools to $PREFIX"

if ! command -v kubectl >/dev/null 2>&1; then
    VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
    echo "Installing kubectl version $VERSION"
    curl -LO "https://storage.googleapis.com/kubernetes-release/release/$VERSION/bin/darwin/amd64/kubectl"
    chmod +x kubectl
    mv kubectl "$PREFIX"
    echo "kubectl installed!"
else
    echo "kubetcl is already installed"
fi

if ! command -v minikube >/dev/null 2>&1; then
    curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64
    chmod +x minikube
    mv minikube "$PREFIX"
    echo "minikube installed!"
else
    echo "minikube is already installed"
fi

# install Terraform

echo "Attempting to install Terraform to $PREFIX"

if ! command -v terraform >/dev/null 2>&1; then
    curl -Lo terraform.zip https://releases.hashicorp.com/terraform/0.14.0/terraform_0.14.0_darwin_amd64.zip
    echo "Unzipping Terraform..."
    unzip terraform.zip
    chmod +x terraform
    mv terraform "$PREFIX"
    echo "Terraform installed!"
else
    echo "Terraform is already installed"
fi

# run new minkube cluster

echo "Starting minikube..."
minikube start --kubernetes-version="$VERSION"

# ensure context

minikube update-context

# plug in to minikube docker daemon

eval "$(minikube -p minikube docker-env)"

# build docker container

echo "Building Docker image..."
docker build -t hello-world:1.0.0 ../src

echo "Starting minikube loadbalancer..."

(
    # sudo -S minikube tunnel -c
    minikube tunnel
) >/dev/null &

echo "Loadbalancer started..."

# init terraform

terraform -chdir="../deploy" init

