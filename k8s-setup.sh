#!/bin/bash

# Source: http://kubernetes.io/docs/getting-started-guides/kubeadm/
echo ".........----------------#################.........----------------#################.........----------------11111111111111111"
### setup terminal
apt-get install -y bash-completion binutils
echo 'colorscheme ron' >> ~/.vimrc
echo 'set tabstop=2' >> ~/.vimrc
echo 'set shiftwidth=2' >> ~/.vimrc
echo 'set expandtab' >> ~/.vimrc
echo 'source <(kubectl completion bash)' >> ~/.bashrc
echo 'alias k=kubectl' >> ~/.bashrc
echo 'alias c=clear' >> ~/.bashrc
echo 'complete -F __start_kubectl k' >> ~/.bashrc
sed -i '1s/^/force_color_prompt=yes\n/' ~/.bashrc

echo ".........----------------#################.........----------------#################.........----------------22222222222222222"
### install k8s and docker
### install jq, pip3 and jc
apt-get remove -y docker.io kubelet kubeadm kubectl kubernetes-cni
apt-get autoremove -y
apt-get install -y etcd-client vim build-essential
apt-get update
apt-get install -y jq && apt install -y python3-pip && pip3 install jc

### UUID of VM
jc dmidecode | jq .[1].values.uuid -r

systemctl daemon-reload

echo ".........----------------#################.........----------------#################.........----------------33333333333333333"
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF > /etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
KUBE_VERSION=1.20.2
apt-get update
apt-get install -y docker.io kubelet=${KUBE_VERSION}-00 kubeadm=${KUBE_VERSION}-00 kubectl=${KUBE_VERSION}-00 kubernetes-cni=0.8.7-00

cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "storage-driver": "overlay2"
}
EOF
mkdir -p /etc/systemd/system/docker.service.d

# Restart docker.
systemctl daemon-reload
systemctl restart docker

# start docker on reboot
systemctl enable docker

docker info | grep -i "storage"
docker info | grep -i "cgroup"

systemctl enable kubelet && systemctl start kubelet


### init k8s
rm /root/.kube/config
kubeadm reset -f
kubeadm init --kubernetes-version=${KUBE_VERSION} --ignore-preflight-errors=NumCPU --skip-token-print

mkdir -p ~/.kube
sudo cp -i /etc/kubernetes/admin.conf ~/.kube/config

kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

sleep 60

echo
echo "untaint controlplane node"
kubectl taint node $(kubectl get nodes -o=jsonpath='{.items[].metadata.name}')  node-role.kubernetes.io/master-
echo ".........----------------#################.........----------------#################.........----------------44444444444444444444"
# for Q6
mkdir /opt/k8s
cat << EOF > /tmp/mysql-pod.logs
    - MYSQL_ROOT_PASSWORD
    - MYSQL_ALLOW_EMPTY_PASSWORD
    - MYSQL_RANDOM_ROOT_PASSWORD
EOF

# Git
cat << EOF > /root/.ssh/id_ed25519
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
QyNTUxOQAAACAT7kDjcmtLpvQfpwnV+HWe3+5yV2qIm4f2uFKbor2C9wAAAKgkE9HvJBPR
7wAAAAtzc2gtZWQyNTUxOQAAACAT7kDjcmtLpvQfpwnV+HWe3+5yV2qIm4f2uFKbor2C9w
AAAEBBdONeYY3a81+xgCYF71q3CYkfuIJZl314mVOG+TcauhPuQONya0um9B+nCdX4dZ7f
7nJXaoibh/a4UpuivYL3AAAAH2JhcmFoYWxpa2FyLnNpZGRoYXJ0aEBnbWFpbC5jb20BAg
MEBQY=
-----END OPENSSH PRIVATE KEY-----
EOF

chmod 400 /root/.ssh/id_ed25519
touch /root/.ssh/config
cat << EOF > /root/.ssh/config
Host gitlab.com
    StrictHostKeyChecking no
EOF

kubectl apply -f https://raw.githubusercontent.com/sidd-harth/shell/main/cluster-config.yaml

mkdir /var/lib/complete-test && cd /var/lib/complete-test && wget https://raw.githubusercontent.com/sidd-harth/shell/main/test-clean.sh

echo ".........----------------#################.........----------------#################.........----------------555555555555555555555555"