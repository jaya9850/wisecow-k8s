
# 🐮 Wisecow – DevOps Practical Assessment (Accuknox 2025)

## 📘 Overview
This repository contains the implementation of the **Accuknox DevOps Trainee Practical Assessment**.  
It includes **containerization, Kubernetes deployment, CI/CD pipeline**, and **system monitoring scripts** for the Wisecow application.

---

## 🧩 Problem Statement 1  
**Title:** Containerisation and Deployment of Wisecow Application on Kubernetes  
**Original App Repo:** [nyrahul/wisecow](https://github.com/nyrahul/wisecow)

### 🎯 Objective
To containerize and deploy the Wisecow application on a Kubernetes cluster (Minikube) with:
- Secure **TLS communication**
- Automated **CI/CD pipeline** using GitHub Actions
- Working **Kubernetes Service and Ingress**

---

## ⚙️ Project Structure
```

wisecow/
├── .github/
│   └── workflows/
│       └── ci-cd.yml
├── k8s/
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingress.yaml
├── scripts/
│   ├── system_health.sh
│   └── app_health_check.sh
├── Dockerfile
└── README.md

````

---

## 🐳 Step 1 — Dockerization

### 1️⃣ Create Dockerfile

     1  FROM ubuntu:20.04
     2  ENV DEBIAN_FRONTEND=noninteractive
     3  ENV PATH="/usr/games:${PATH}"
     4  WORKDIR /app
     5
     6  RUN apt-get update && apt-get install -y \
     7      fortune cowsay netcat dos2unix \
     8      && rm -rf /var/lib/apt/lists/*
     9
    10  COPY wisecow.sh /app/wisecow.sh
    11  RUN dos2unix /app/wisecow.sh && chmod +x /app/wisecow.sh
    12
    13  EXPOSE 4499
    14  CMD ["/app/wisecow.sh"]
    

### 2️⃣ Build Image

```bash
docker build -t pratiksha9850/wisecow:latest .
```

### 3️⃣ Test Locally

```bash
docker run --rm -it pratiksha9850/wisecow:latest
```

---

## ☸️ Step 2 — Kubernetes Deployment (Minikube)

### 1️⃣ Start Cluster

```bash
minikube start --driver=docker
minikube addons enable ingress
```

### 2️⃣ Load Image into Minikube

```bash
eval $(minikube -p minikube docker-env)
docker build -t pratiksha9850/wisecow:latest .
```

### 3️⃣ Apply Manifests

```bash
kubectl apply -f k8s/
kubectl get pods,svc,ingress
```

### 4️⃣ Create TLS Secret

```bash
openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 -keyout key.pem -out cert.pem \
  -subj "/CN=wisecow.local/O=wisecow"

kubectl create secret tls wisecow-tls --cert=cert.pem --key=key.pem
```

### 5️⃣ Add Host Mapping

```bash
sudo -- sh -c 'echo "127.0.0.1 wisecow.local" >> /etc/hosts'
```

### 6️⃣ Access Application

Visit → **[https://wisecow.local](https://wisecow.local)** (accept self-signed certificate)

---

## 🤖 Step 3 — CI/CD Pipeline (GitHub Actions)

### 🧱 Workflow

`.github/workflows/ci-cd.yml` handles:

* Build Docker image
* Push to Docker Hub
* Optional deploy to Kubernetes

### 🧩 Required Secrets

| Secret               | Description                          |
| -------------------- | ------------------------------------ |
| `DOCKERHUB_USERNAME` | Your Docker Hub username             |
| `DOCKERHUB_TOKEN`    | Docker Hub access token              |
| `KUBE_CONFIG`        | (Optional) Base64-encoded kubeconfig |

### 🔐 How to Create Docker Hub Token

1. Go to [Docker Hub → Settings → Security](https://hub.docker.com/settings/security)
2. Click **New Access Token** → name it `github-actions`
3. Copy the token (only shown once)
4. Add to GitHub repo secrets as `DOCKERHUB_TOKEN`

### 🧠 Base64 Encode kubeconfig (Optional)

```bash
cat ~/.kube/config | base64 | tr -d '\n'
```

Add to GitHub Secrets as `KUBE_CONFIG`.

---

## 🧾 Step 4 — Problem Statement 2 Scripts

### 🩺 System Health Monitoring

```bash
chmod +x scripts/system_health.sh
./scripts/system_health.sh
```

Checks CPU, Memory, Disk usage and logs alerts to `system_health.log`.

### 🌐 Application Health Checker

```bash
chmod +x scripts/app_health_check.sh
./scripts/app_health_check.sh https://wisecow.local 200
```

Checks HTTP status and logs uptime/downtime to `app_health.log`.

---

## 🔒 Step 5 — Bonus (Optional): KubeArmor Policy

Example policy to block shell access:

```yaml
apiVersion: security.kubearmor.com/v1
kind: KubeArmorPolicy
metadata:
  name: block-shell-access
  namespace: default
spec:
  severity: 7
  selector:
    matchLabels:
      app: wisecow
  process:
    matchPaths:
      - path: /bin/sh
        action: Block
```

Apply it:

```bash
kubectl apply -f kubearmor-policy.yaml
kubectl get ksp
```

---

## 🧰 Tools Used

| Category         | Tools                 |
| ---------------- | --------------------- |
| Containerization | Docker                |
| Orchestration    | Kubernetes (Minikube) |
| CI/CD            | GitHub Actions        |
| Monitoring       | Bash Scripts          |
| Security         | KubeArmor             |
| OS               | Ubuntu / Linux        |

---

## ✅ Deliverables

* Dockerfile
* Kubernetes YAMLs
* GitHub Actions Workflow
* Monitoring Scripts
* (Optional) KubeArmor Policy
* Complete README.md

---

## 👩‍💻 Author

**Name:** Pratiksha Bhosale
