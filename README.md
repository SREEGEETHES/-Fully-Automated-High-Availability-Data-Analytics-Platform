
# XNL Innovations - Fully Automated Data-Driven, High-Availability System

## 📌 Project Overview
This project builds a **fully automated, high-availability, real-time analytics system** that supports **global data processing, edge computing, disaster recovery, and self-healing infrastructure**. 

---

## 📂 Required Files for Submission
Ensure the following files are uploaded to the GitHub repository:

- **Terraform Configuration Files:** `main.tf`, `variables.tf`, `outputs.tf`
- **Kubernetes Manifests:** `deployment.yaml`, `service.yaml`, `hpa.yaml`
- **CI/CD Pipelines:** `.github/workflows/deploy.yaml` or `Jenkinsfile`
- **Monitoring Dashboards:** Grafana JSON configuration
- **Load Testing Scripts:** `load-test.js`
- **Security Reports:** `zap-report.html`, `kube-bench-report.txt`
- **Architecture Diagram:** `architecture.png`
- **Demo Video:** `demo.mp4`
- **README.md:** (This file itself)

---


## 📷 Architecture Diagram
![Image](https://github.com/user-attachments/assets/6b3cc099-a9fe-4022-8891-e9db0a3c8d73)

---

# 📌 Part 1: Infrastructure Automation (Terraform)

### 🛠️ **1.1 Install & Set Up Terraform**

#### **🔹 Verify Terraform Installation**
```bash
terraform -v  # Check Terraform version
```
📌 **Attach Screenshot:** Terraform version output
![Image](https://github.com/user-attachments/assets/a9459f8e-9000-45b0-bb52-bc6d03d844f1)

#### **🔹 Create Terraform Configuration Files**
```bash
mkdir terraform-setup && cd terraform-setup
nano main.tf  # Create main Terraform configuration file
```
📌 **Attach Screenshot:** `main.tf` content
![Image](https://github.com/user-attachments/assets/fe6490cc-78bf-4b9e-9589-6e70ca48d986)

#### **🔹 Define AWS Provider in `main.tf`**
```hcl
provider "aws" {
  region = "us-east-1"
}
```

#### **🔹 Initialize Terraform**
```bash
terraform init
```
📌 **Attach Screenshot:** Terraform initialization output
  ![Image](https://github.com/user-attachments/assets/92029bb4-fe86-4300-a8a2-a72832c9482f)

#### **🔹 Deploy Infrastructure**
```bash
terraform apply -auto-approve
```


---

### 🛠️ **1.2 Deploy EC2 Instance**

#### **🔹 Define EC2 Instance in `main.tf`**
```hcl
resource "aws_instance" "app_server" {
  ami           = "ami-12345678"  # Replace with the latest Amazon Linux AMI ID
  instance_type = "t2.micro"
  key_name      = "my-key"
}
```

#### **🔹 Apply Configuration**
```bash
terraform apply -auto-approve
```
📌 **Attach Screenshot:** Running EC2 instance
![Image](https://github.com/user-attachments/assets/5389a7bf-660a-4677-a550-e747d375da91)

#### **🔹 Connect to EC2 Instance**
```bash
ssh -i "path/to/key.pem" ec2-user@<EC2-PUBLIC-IP>
```
📌 **Attach Screenshot:** Successful SSH connection
![Image](https://github.com/user-attachments/assets/601b7f16-fbe3-4228-9a8a-34b3b9b2bb53)

---

# 📌 Part 2: Kubernetes Cluster Deployment

### 🛠️ **2.1 Install Kubernetes CLI Tools**

#### **🔹 Install kubectl**
```bash
choco install kubernetes-cli -y  # Windows
sudo apt install kubectl -y  # Linux
```

#### **🔹 Install eksctl**
```bash
choco install eksctl -y  # Windows
sudo curl -sSL "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /usr/local/bin  # Linux
```
📌 **Attach Screenshot:** kubectl and eksctl versions
![Image](https://github.com/user-attachments/assets/b225102c-3995-4993-83f8-9eed7ecf366b)

---

### 🛠️ **2.2 Deploy EKS Cluster**

#### **🔹 Create an EKS Cluster**
```bash
eksctl create cluster --name xnl-eks-cluster --region us-east-1 --nodegroup-name eks-nodes
```
📌 **Attach Screenshot:** EKS Cluster creation logs
![Image](https://github.com/user-attachments/assets/aaa3d194-7bad-48b5-a95e-ca864e0dc996)


#### **🔹 Verify Cluster**
```bash
kubectl get nodes
```
📌 **Attach Screenshot:** Running Kubernetes nodes
![Image](https://github.com/user-attachments/assets/ee74577b-4297-4174-a3c0-b888f0e3ebce)

---

# 📌 Part 3: Deploy & Expose an Application

### 🛠️ **3.1 Deploy Nginx to Kubernetes**

#### **🔹 Deploy Nginx**
```bash
kubectl create deployment nginx --image=nginx
```


#### **🔹 Expose Deployment**
```bash
kubectl expose deployment nginx --type=LoadBalancer --port=80
```
📌 **Attach Screenshot:** Kubernetes service details
![Image](https://github.com/user-attachments/assets/7a3b964d-e8c5-4ec4-9a35-6d51fe4de8b9)

---

# 📌 Part 4: Security & Compliance

### 🛠️ **4.1 Run Security Scans**

#### **🔹 Install OWASP ZAP**
```bash
choco install zap -y
```

#### **🔹 Scan for Vulnerabilities**
```bash
zap-baseline.py -t http://your-load-balancer-url -r zap-report.html
```
📌 **Attach Screenshot:** Security scan results
![Image](https://github.com/user-attachments/assets/7b775434-a97f-4463-8f46-c46884ac8b28)

---

# 📌 Part 5: Performance Optimization & Load Testing

### 🛠️ **5.1 Install Load Testing Tools**

#### **🔹 Install k6**
```bash
choco install k6 -y  # Windows
sudo apt install k6 -y  # Linux
```

#### **🔹 Run Load Test**
Create `load-test.js`:
```javascript
import http from 'k6/http';
import { check } from 'k6';

export default function () {
    let res = http.get('http://your-load-balancer-url');
    check(res, { 'status was 200': (r) => r.status == 200 });
}
```
Run the test:
```bash
k6 run load-test.js
```
📌 **Attach Screenshot:** Load test results
![Image](https://github.com/user-attachments/assets/d36d3f99-368a-4021-b3ef-7e7ac0d5bf83)

---

# 📌 Part 6: Monitoring & Logging

### 🛠️ **6.1 Set Up Prometheus & Grafana**

#### **🔹 Deploy Prometheus Operator**
```bash
kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/kube-prometheus/main/manifests/setup/prometheus-operator.yaml
```
📌 **Attach Screenshot:** Prometheus running pods
![Image](https://github.com/user-attachments/assets/1a9c3739-8760-4de7-969b-54233a7ad322)
![Image](https://github.com/user-attachments/assets/3efead73-22f0-4d7f-afd8-a0ec8e7c97c3)
![Image](https://github.com/user-attachments/assets/160b1cbe-8271-4341-9a12-a98f02777ffc)
![Image](https://github.com/user-attachments/assets/18832e1c-22a5-4cf5-8780-8d5426f7f2a2)
![Image](https://github.com/user-attachments/assets/bc4b8554-0547-42cb-b122-a1cb71cf2cc9)
![Image](https://github.com/user-attachments/assets/ab6625a0-02fe-4c0e-8a15-0ac39cc46be5)


---


---

## 🚀 Conclusion
This guide provides a **detailed, step-by-step execution** of building a **fully automated, high-availability data-driven system**. Let me know if you need any modifications! 🔥
