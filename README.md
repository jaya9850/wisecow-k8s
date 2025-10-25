## Wisecow - Assignment repo (containerize + k8s + CI/CD)

### Quick local run (minikube)
1. Start minikube:
   minikube start --driver=docker
   minikube addons enable ingress

2. Build image into minikube (so Kubernetes can use it without pulling):
   eval $(minikube -p minikube docker-env)
   docker build -t yourdockerhubuser/wisecow:latest .

3. Apply k8s manifests:
   kubectl apply -f k8s/

4. Create TLS secret (optional, for ingress TLS):
   openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout key.pem -out cert.pem -subj "/CN=wisecow.local/O=wisecow"
   kubectl create secret tls wisecow-tls --cert=cert.pem --key=key.pem

5. Add host mapping:
   sudo -- sh -c 'echo "127.0.0.1 wisecow.local" >> /etc/hosts'

6. Check pods and access:
   kubectl get pods,svc,ingress
   Visit: https://wisecow.local  (accept self-signed cert)

### CI/CD (GitHub Actions)
- Workflow `.github/workflows/ci-cd.yml` builds image and pushes to Docker Hub.
- Set repo secrets: DOCKERHUB_USERNAME, DOCKERHUB_TOKEN.
- Optional KUBE_CONFIG secret to enable automatic deploy step.

### Scripts
- scripts/system_health.sh — simple system monitoring
- scripts/app_health_check.sh — HTTP status checker
