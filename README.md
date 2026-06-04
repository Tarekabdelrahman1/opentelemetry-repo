# Ultimate DevOps GitOps Project 🚀

Welcome to the **Ultimate DevOps Project Demo**! This repository showcases an end-to-end, fully automated GitOps pipeline for a complex, polyglot microservices architecture hosted on AWS.
<img width="1856" height="838" alt="image" src="https://github.com/user-attachments/assets/31a688ee-8569-49d7-a18d-8d8ce3053866" />


## 📖 Overview

This project demonstrates how to manage a modern cloud-native application ecosystem using industry-standard DevOps practices. From infrastructure provisioning to application deployment, everything is automated, reproducible, and version-controlled.

## 🏗️ Architecture & Flow

1. **Infrastructure Provisioning:** `eksctl` provisions the Amazon EKS (Elastic Kubernetes Service) cluster and underlying networking.
2. **Continuous Integration (CI):** GitHub Actions automatically lints, tests, and builds Docker images on every commit, pushing them to the container registry.
3. **Continuous Deployment (CD):** Argo CD operates on GitOps principles, monitoring the `kubernetes/` manifests directory and automatically synchronizing the EKS cluster state.
4. **Traffic Management:** The AWS Application Load Balancer (ALB) Controller securely manages external traffic routing to the internal microservices using OIDC and IAM roles.

## 🛠️ Technology Stack

* **Cloud Provider:** AWS (EKS, EC2, ALB, IAM)
* **Container Orchestration:** Kubernetes (Amazon EKS)
* **CI/CD:** GitHub Actions & Argo CD
* **Ingress/Networking:** AWS Load Balancer Controller
* **Containers:** Docker
* **Microservices:** Polyglot stack (Go, Java, C#/.NET, Python, Node.js)
* **Local Development:** `docker-compose` and `Makefile`

## 📁 Repository Structure

```text
.
├── .github/             # GitHub Actions CI workflows
├── kubernetes/          # Kubernetes manifests (Deployments, Services, Ingress)
├── src/                 # Source code for all microservices (ad, cart, checkout, etc.)
├── docker-compose.yml   # Local development orchestration
└── Makefile             # Task automation (build, run, test)

```

## 🚀 Getting Started

### Local Development

To run the microservices locally for testing and development:

1. Ensure you have **Docker** and **Docker Compose** installed.
2. Run the provided make command (or docker-compose):

```bash
make run
# OR
docker-compose up --build

```

### Cloud Deployment (AWS EKS)

#### 1. Provision Infrastructure

Create the EKS cluster using `eksctl`:

```bash
eksctl create cluster \
  --name my-eks-cluster \
  --region us-west-2 \
  --nodegroup-name general \
  --node-type t3.medium \
  --nodes 2 \
  --nodes-min 1 \
  --nodes-max 3

```

#### 2. Configure OIDC & AWS Load Balancer Controller

To expose our frontend securely, establish trust between EKS and AWS IAM:

**Enable OIDC & Export Variables:**

```bash
eksctl utils associate-iam-oidc-provider --cluster=my-eks-cluster --region=us-west-2 --approve
export ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
export OIDC_PROVIDER=$(aws eks describe-cluster --name my-eks-cluster --region us-west-2 --query "cluster.identity.oidc.issuer" --output text | sed -e "s/^https:\/\///")

```

**Create IAM Policy & Role:**

```bash
curl -O [https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.11.0/docs/install/iam_policy.json](https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.11.0/docs/install/iam_policy.json)
aws iam create-policy --policy-name AWSLoadBalancerControllerIAMPolicy --policy-document file://iam_policy.json

cat <<EOF> trust-policy.json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::${ACCOUNT_ID}:oidc-provider/${OIDC_PROVIDER}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "${OIDC_PROVIDER}:aud": "sts.amazonaws.com",
          "${OIDC_PROVIDER}:sub": "system:serviceaccount:kube-system:aws-load-balancer-controller"
        }
      }
    }
  ]
}
EOF

aws iam create-role --role-name AmazonEKSLoadBalancerControllerRole --assume-role-policy-document file://trust-policy.json
aws iam attach-role-policy --role-name AmazonEKSLoadBalancerControllerRole --policy-arn arn:aws:iam::${ACCOUNT_ID}:policy/AWSLoadBalancerControllerIAMPolicy

```

**Install Controller via Helm:**

```bash
cat <<EOF> target-sa.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    app.kubernetes.io/component: controller
    app.kubernetes.io/name: aws-load-balancer-controller
  name: aws-load-balancer-controller
  namespace: kube-system
  annotations:
    [eks.amazonaws.com/role-arn](https://eks.amazonaws.com/role-arn): arn:aws:iam::${ACCOUNT_ID}:role/AmazonEKSLoadBalancerControllerRole
EOF
kubectl apply -f target-sa.yaml

helm repo add eks [https://aws.github.io/eks-charts](https://aws.github.io/eks-charts)
helm repo update
# Note: Replace <YOUR_VPC_ID> with your actual EKS VPC ID
helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=my-eks-cluster --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller --set vpcId=<YOUR_VPC_ID> --set region=us-west-2

```

#### 3. Application & Ingress Deployment

Deploy your application manifests and create the AWS ALB:

```bash
kubectl apply -f kubernetes/

cat <<EOF> ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: frontend-proxy
  annotations:
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
spec:
  ingressClassName: alb
  rules:
    - host: example.com
      http:
        paths:
          - path: "/"
            pathType: Prefix
            backend:
              service:
                name: opentelemetry-demo-frontendproxy
                port:
                  number: 8080
EOF
kubectl apply -f ingress.yaml

```

*(Note: Map the generated ALB IP to `example.com` in your local `/etc/hosts` file to access the app).*

#### 4. Configure CI/CD (GitOps with Argo CD)

Install Argo CD and expose the UI:

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f [https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml](https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml)

# Expose Argo CD Server
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

# Retrieve Initial Admin Password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

```

Log in to the Argo CD UI using `admin` and the decoded password, then connect your GitHub repository to monitor the `kubernetes/` directory. Ensure your GitHub Actions workflow (`.github/workflows/ci.yaml`) is configured with your container registry credentials.

#### 5. Cleanup / Teardown

To avoid unwanted AWS charges, destroy the infrastructure in this exact order:

```bash
# 1. Delete Ingress to remove the AWS ALB
kubectl delete ingress frontend-proxy

# 2. Delete EKS Cluster
eksctl delete cluster --name my-eks-cluster --region us-west-2

# 3. Detach and Delete IAM Policies and Roles
aws iam detach-role-policy --role-name AmazonEKSLoadBalancerControllerRole --policy-arn arn:aws:iam::${ACCOUNT_ID}:policy/AWSLoadBalancerControllerIAMPolicy
aws iam delete-role --role-name AmazonEKSLoadBalancerControllerRole
aws iam delete-policy --policy-arn arn:aws:iam::${ACCOUNT_ID}:policy/AWSLoadBalancerControllerIAMPolicy

