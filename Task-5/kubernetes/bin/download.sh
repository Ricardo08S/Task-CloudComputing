#curl -LO https://github.com/k0sproject/k0sctl/releases/download/v0.16.0/k0sctl-linux-x64
curl -Lo ./rke  https://github.com/rancher/rke/releases/download/v1.4.10/rke_linux-amd64
chmod a+x ./rke

curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64 
chmod a+x ./kind

curl -Lo ./kubectl  "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod a+x ./kubectl


export PATH=$PATH:$(pwd)



