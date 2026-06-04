# Ultimate DevOps GitOps Project 🚀

Welcome to the **Ultimate DevOps Project Demo**! This repository showcases an end-to-end, fully automated GitOps pipeline for a complex, polyglot microservices architecture hosted on AWS.
<img width="1856" height="838" alt="image" src="https://github.com/user-attachments/assets/cea8ae0b-d06a-4389-94c3-aa6c0d48eef6" />

## 📖 Overview

This project demonstrates how to manage a modern cloud-native application ecosystem (Java, .NET, Go, Python, Next.js) using industry-standard DevOps practices. From infrastructure provisioning to application deployment, everything is automated, reproducible, and version-controlled.

## 🏗️ Architecture & Flow

1. **Infrastructure as Code (IaC):** Terraform provisions the AWS networking (VPC, Subnets) and the Amazon EKS (Elastic Kubernetes Service) cluster.
2. **Continuous Integration (CI):** GitHub Actions automatically lints, tests, and builds multi-architecture Docker images on every commit, pushing them to the container registry.
3. **Continuous Deployment (CD):** ArgoCD operates on GitOps principles, monitoring the `kubernetes/` manifests directory and automatically synchronizing the EKS cluster state.
4. **Traffic Management:** An NGINX Ingress Controller manages external traffic routing to the internal microservices.

## 🛠️ Technology Stack

* **Cloud Provider:** AWS (Amazon Web Services)
* **Infrastructure as Code:** Terraform
* **Container Orchestration:** Kubernetes (Amazon EKS)
* **CI/CD:** GitHub Actions & ArgoCD
* **Containers:** Docker, multi-arch builds
* **Ingress/Networking:** NGINX Ingress Controller
* **Microservices:** Polyglot stack (Go, Java, C#/.NET, Python, Node.js)
* **Local Development:** `docker-compose` and `Makefile`

## 📁 Repository Structure


```

```text
Code executed successfully!
```text
.
├── .github/             # GitHub Actions CI workflows
├── EKS-create/          # Terraform modules for VPC and EKS provisioning
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

Navigate to the Terraform directory to create the EKS cluster and VPC:

```bash
cd EKS-create/
terraform init
terraform plan
terraform apply --auto-approve

```

#### 2. Configure CI/CD

* Update the GitHub Actions workflow files in `.github/workflows/` with your container registry credentials.
* Install ArgoCD on your EKS cluster and connect it to this GitHub repository to monitor the `kubernetes/` directory.

#### 3. Access the Application

Once ArgoCD syncs the state, retrieve your NGINX Ingress load balancer URL to access the frontend:

```bash
kubectl get ingress -n default

```

## 🤝 Contributing

Feel free to fork this project, submit pull requests, or open issues if you find bugs or want to suggest new features!
"""

with open('README.md', 'w', encoding='utf-8') as f:
f.write(readme_content)

```
Your MD file is ready
[file-tag: code-generated-file-0-1780578810148077836]

Here is the raw Markdown content as well so you can easily copy and paste it directly into your project:

```markdown
# Ultimate DevOps GitOps Project 🚀

Welcome to the **Ultimate DevOps Project Demo**! This repository showcases an end-to-end, fully automated GitOps pipeline for a complex, polyglot microservices architecture hosted on AWS.

## 📖 Overview

This project demonstrates how to manage a modern cloud-native application ecosystem (Java, .NET, Go, Python, Next.js) using industry-standard DevOps practices. From infrastructure provisioning to application deployment, everything is automated, reproducible, and version-controlled.

## 🏗️ Architecture & Flow

1. **Infrastructure as Code (IaC):** Terraform provisions the AWS networking (VPC, Subnets) and the Amazon EKS (Elastic Kubernetes Service) cluster.
2. **Continuous Integration (CI):** GitHub Actions automatically lints, tests, and builds multi-architecture Docker images on every commit, pushing them to the container registry.
3. **Continuous Deployment (CD):** ArgoCD operates on GitOps principles, monitoring the `kubernetes/` manifests directory and automatically synchronizing the EKS cluster state.
4. **Traffic Management:** An NGINX Ingress Controller manages external traffic routing to the internal microservices.

## 🛠️ Technology Stack

* **Cloud Provider:** AWS (Amazon Web Services)
* **Infrastructure as Code:** Terraform
* **Container Orchestration:** Kubernetes (Amazon EKS)
* **CI/CD:** GitHub Actions & ArgoCD
* **Containers:** Docker, multi-arch builds
* **Ingress/Networking:** NGINX Ingress Controller
* **Microservices:** Polyglot stack (Go, Java, C#/.NET, Python, Node.js)
* **Local Development:** `docker-compose` and `Makefile`

## 📁 Repository Structure

```text
.
├── .github/             # GitHub Actions CI workflows
├── EKS-create/          # Terraform modules for VPC and EKS provisioning
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

Navigate to the Terraform directory to create the EKS cluster and VPC:

```bash
cd EKS-create/
terraform init
terraform plan
terraform apply --auto-approve

```

#### 2. Configure CI/CD

* Update the GitHub Actions workflow files in `.github/workflows/` with your container registry credentials.
* Install ArgoCD on your EKS cluster and connect it to this GitHub repository to monitor the `kubernetes/` directory.

#### 3. Access the Application

Once ArgoCD syncs the state, retrieve your NGINX Ingress load balancer URL to access the frontend:

```bash
kubectl get ingress -n default

```


```

```
