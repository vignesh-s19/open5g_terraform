#!/bin/bash.
sudo snap install microk8s --classic
sudo usermod -aG microk8s ubuntu
sudo mkdir -p /home/ubuntu/.kube
sudo chown -Rf ubuntu /home/ubuntu/.kube
sudo microk8s enable dns ingress
sudo microk8s kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/v0.0.22/deploy/local-path-storage.yaml
sudo microk8s kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
sudo snap alias microk8s.kubectl kubectl
sudo snap alias microk8s.helm helm
# sudo curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
# sudo chmod 700 get_helm.sh
# sudo ./get_helm.sh
sudo helm repo add openverso https://gradiant.github.io/openverso-charts/
sudo helm install open5gs openverso/open5gs --version 2.0.8 --values https://gradiant.github.io/openverso-charts/docs/open5gs-ueransim-gnb/5gSA-values.yaml

# sudo helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
# sudo helm repo add stable https://charts.helm.sh/stable
# sudo helm repo update
# sudo helm install prometheus prometheus-community/kube-prometheus-stack
