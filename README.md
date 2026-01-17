# Java CI/CD Deployment on AWS with Jenkins, Terraform & Ansible

## 📌 Project Overview

This project demonstrates an **end-to-end CI/CD pipeline** for deploying a **WAR-based Java application** to **Apache Tomcat** running on **AWS EC2**. It uses modern DevOps tools and best practices, covering **Infrastructure as Code (IaC)**, **Configuration Management**, **Continuous Integration**, and **Continuous Deployment**.

The application source code is hosted on GitHub and is automatically built, tested, and deployed whenever changes are pushed to the repository.

---

## 🛠️ Technology Stack

| Category                 | Tool                                    |
| ------------------------ | --------------------------------------- |
| Cloud Provider           | AWS EC2                                 |
| Infrastructure as Code   | Terraform                               |
| Configuration Management | Ansible                                 |
| CI/CD                    | Jenkins                                 |
| Build Tool               | Maven                                   |
| Runtime                  | Java 11                                 |
| Application Server       | Apache Tomcat 9                         |
| Source Code              | simple-java-docker (WAR-based Java app) |
| Version Control          | GitHub                                  |


---

## 🏗️ Architecture

```
Developer Push → GitHub Webhook
                ↓
            Jenkins CI/CD
                ↓
        Maven Build & Test
                ↓
      Deploy WAR to Tomcat
                ↓
        Application Live on
      http://<EC2-IP>:8080/app
```

---

## 📂 Project Structure

```
simple-java-docker/
├── Jenkinsfile
├── README.md
├── pom.xml
├── src/
│   └── main/
│       ├── java/
│       └── webapp/
│           ├── index.jsp
│           └── WEB-INF/
│               └── web.xml
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── ansible/
│   ├── inventory
│   └── tomcat-setup.yml
```

---

## ☁️ Infrastructure Provisioning (Terraform)

Terraform is used to provision AWS infrastructure:

### Resources Created

* EC2 Instance (Ubuntu)
* Security Group

  * Port 22 (SSH)
  * Port 8080 (Tomcat)
* Key Pair
  


### Steps

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

After deployment, Terraform outputs the **EC2 public IP**, which is used by Ansible and Jenkins.
<img width="1792" height="1120" alt="Screenshot 2026-01-16 at 7 22 24 PM" src="https://github.com/user-attachments/assets/7cbc6cfc-37cb-46e3-8e5d-32fe6e67cf5a" />
<img width="1792" height="1120" alt="Screenshot 2026-01-16 at 1 47 49 PM" src="https://github.com/user-attachments/assets/adffb903-1a49-4ee8-b66d-8732d593bb0b" />





---

## ⚙️ Configuration Management (Ansible)

Ansible is used to configure the EC2 instance:

### Installed & Configured

* Java 11 (OpenJDK)
* Apache Tomcat 9
* Tomcat users & roles
* Manager & Host-Manager access

### Run Ansible Playbook

```bash
cd ansible
ansible-playbook -i inventory tomcat-setup.yml
```

---

## 🔁 CI/CD Pipeline (Jenkins)

### Jenkins Responsibilities

* Pull source code from GitHub
* Build WAR using Maven
* Run tests
* Deploy WAR to Tomcat
* Perform health check

### Jenkinsfile Stages

1. **Checkout** – Pulls code from GitHub
2. **Build** – `mvn clean package`
3. **Test** – Runs unit tests
4. **Deploy** – Deploys WAR via Tomcat Manager
5. **Health Check** – Validates app availability
   <img width="1792" height="1120" alt="Screenshot 2026-01-16 at 11 01 13 AM" src="https://github.com/user-attachments/assets/0b35c6dd-7adf-4dc4-851c-c16603d22f18" />
   <img width="1792" height="1120" alt="Screenshot 2026-01-16 at 11 34 59 AM" src="https://github.com/user-attachments/assets/2e01acec-f23a-4fda-966e-85500e181e43" />
<img width="1792" height="1120" alt="Screenshot 2026-01-16 at 1 45 58 PM" src="https://github.com/user-attachments/assets/0b19e5dc-9623-4d35-8af5-7a4a79b44a4e" />
<img width="1792" height="1120" alt="Screenshot 2026-01-16 at 11 35 06 AM" src="https://github.com/user-attachments/assets/cb7a9f1e-e4aa-41d9-aa3e-90e92656b44c" />




---

## 🔐 Jenkins Credentials Used

| Credential         | Purpose                         |
| ------------------ | ------------------------------- |
| tomcat-credentials | Tomcat Manager authentication   |
| github-token       | GitHub webhook & API access     |
| jenkins            | Jenkins internal authentication |

---

## 🔗 GitHub Webhook Integration

The pipeline is automatically triggered when code is pushed to GitHub.

### Webhook Configuration

* Payload URL:

```
http://<JENKINS-IP>:8080/github-webhook/
```

* Content type: `application/json`
* Trigger: `Just the push event`
  <img width="1792" height="1120" alt="Screenshot 2026-01-16 at 1 34 53 PM" src="https://github.com/user-attachments/assets/6eeb0347-7e1f-4f5c-a99e-76541fe236bc" />
  <img width="1792" height="1120" alt="Screenshot 2026-01-16 at 1 31 06 PM" src="https://github.com/user-attachments/assets/8fc5c92e-5b8f-404d-aab4-3bbcaa6affd6" />



---

## 🚀 Application Deployment

The application is deployed as a **WAR file** to Tomcat:

```
/opt/tomcat/webapps/simple-java-app
```

### Access Application

```
http://<EC2-PUBLIC-IP>:8080/simple-java-app/
```
<img width="1792" height="1120" alt="Screenshot 2026-01-16 at 12 08 11 PM" src="https://github.com/user-attachments/assets/24b430be-f61f-4368-97cb-aaca6ebd5c75" />


---

## ❤️ Health Check Logic

The pipeline validates deployment using:

```bash
curl -L http://<EC2-IP>:8080/simple-java-app/
```

Accepted HTTP responses:

* `200 OK`
* `302 Redirect`
<img width="1792" height="1120" alt="Screenshot 2026-01-16 at 11 34 59 AM" src="https://github.com/user-attachments/assets/698c8c3e-251b-4b15-974c-cc4e9b13def7" />

---

## 🧪 Common Issues & Fixes

### 404 Error After Deployment

<img width="1792" height="1120" alt="Screenshot 2026-01-16 at 10 18 29 AM" src="https://github.com/user-attachments/assets/d9617df3-1631-4d4a-8efe-e213042e0ac5" />
<img width="1792" height="1120" alt="Screenshot 2026-01-16 at 3 15 02 PM" src="https://github.com/user-attachments/assets/ded248ce-768d-434a-a0ff-98383967ca7b" />



* Missing `index.jsp` or `index.html`
* Incorrect context path

### Jenkins Cannot Find Jenkinsfile

* Jenkinsfile not at repo root
* Wrong branch configured

### Tomcat Deployment Fails

* Incorrect manager credentials
* Manager app access restricted

---

## ✅ Best Practices Applied

* Infrastructure as Code (Terraform)
* Configuration as Code (Ansible)
* Automated CI/CD (Jenkins)
* Secure credential handling
* Health checks after deployment

---

## 📈 Future Improvements

* Add Docker & Kubernetes
* HTTPS with ALB + ACM
* Blue-Green deployment
* Monitoring with Prometheus & Grafana

