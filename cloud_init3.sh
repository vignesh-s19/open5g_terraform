#!/bin/bash
sudo snap install microk8s --classic
sudo usermod -aG microk8s ubuntu
sudo mkdir -p /home/ubuntu/.kube
sudo chown -Rf ubuntu /home/ubuntu/.kube
sudo microk8s enable dns ingress
sudo microk8s kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/v0.0.22/deploy/local-path-storage.yaml
sudo microk8s kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
sudo snap alias microk8s.kubectl kubectl
sudo snap alias microk8s.helm helm
sudo helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
sudo helm repo add stable https://charts.helm.sh/stable
sudo helm repo update
sudo helm install prometheus prometheus-community/kube-prometheus-stack