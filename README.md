# Azure Infrastructure Automation using Terraform & Azure DevOps

![alt text](<Terraform 1.9.8 Purple Badge.png>)
![alt text](<Microsoft Azure Cloud Badge.png>)
![alt text](<Azure DevOps CI_CD Badge.png>)
![alt text](<Infrastructure as Code with Terraform.png>)

## 1. Project Overview

This project demonstrates end-to-end Azure infrastructure automation using **Terraform** and **Azure DevOps CI/CD pipelines**.

The solution uses reusable Terraform modules to provision Azure infrastructure. Terraform state is stored remotely in Azure Blob Storage, and Azure DevOps automates infrastructure validation, planning, manual approval, and deployment.

Azure Workload Identity Federation (OIDC) provides secure authentication between Azure DevOps and Microsoft Azure without storing client secrets in pipeline YAML.

**Project objectives:**
- Automate Azure infrastructure provisioning using Terraform.
- Implement reusable and modular Terraform configurations.
- Manage Terraform state using Azure Blob Storage.
- Implement secure Azure authentication using OIDC.
- Automate Terraform CI/CD using Azure DevOps.
- Introduce manual approval before infrastructure deployment.

## 2. Technology Stack

| Technology | Purpose |
|---|---|
| Microsoft Azure | Cloud infrastructure |
| Terraform 1.9.8 | Infrastructure as Code |
| Azure DevOps | CI/CD automation |
| GitHub | Source code management |
| Azure Blob Storage | Remote Terraform state |
| Workload Identity Federation | Secure Azure authentication |
| Azure CLI | Azure administration |
| PowerShell | Local administration |
| YAML | Pipeline configuration |

## 3. Architecture

### Infrastructure and CI/CD workflow

```text
                  Developer
                      |
                      v
                   GitHub
                (Source Code)
                      |
                      v
               Azure Pipelines
                      |
                      v
             Azure OIDC Authentication
                      |
                      v
                Terraform CI
              Init / Validate
                   / Plan
                      |
                      v
              Publish Plan Artifact
                      |
                      v
                Terraform CD
                Review Plan
                      |
                      v
               Manual Approval
                      |
                      v
               Terraform Apply
                      |
                      v
               Microsoft Azure
                      |
          +-----------+-----------+
          |                       |
          v                       v
    Azure Resources         Azure Blob Storage
                            Remote Terraform
                                 State
```

## 4. Azure Infrastructure

The project provisions and manages the following resources:

- Azure Resource Group
- Azure Virtual Network
- Azure Subnet
- Network Security Group
- Network Security Rules
- Subnet and NSG Association
- Azure Storage Account
- Private Storage Container

### Network configuration

| Component | Configuration |
|---|---|
| Resource Group | `rg-dev` |
| Location | East US |
| Virtual Network | `vnet-dev` |
| Address Space | `10.0.0.0/16` |
| Subnet | `subnet-dev-web` |
| Subnet Address | `10.0.1.0/24` |
| Network Security Group | `nsg-dev-web` |
| HTTP | TCP 80 |
| HTTPS | TCP 443 |

SSH and RDP inbound access rules are not included in the current configuration.

## 5. Terraform Project Structure

```text
Azure-DevOps-Terraform/
│
├── modules/
│   ├── network/
│   ├── nsg/
│   ├── nsg-association/
│   ├── resource-group/
│   ├── storage/
│   └── subnet/
│
├── terraform/
│   ├── backend.tf
│   ├── main.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── terraform.tfvars
│   ├── variables.tf
│   └── versions.tf
│
├── screenshots/
│
├── azure-pipelines.yml
├── README.md
└── .gitignore
```

### Terraform module descriptions

| Module | Responsibility |
|---|---|
| resource-group | Creates Azure Resource Group |
| network | Creates Virtual Network |
| subnet | Creates Azure Subnet |
| nsg | Creates NSG and security rules |
| nsg-association | Associates NSG with subnet |
| storage | Creates Storage Account and private container |

## 6. Remote Terraform State Management

Terraform state is stored in Azure Blob Storage.

| Configuration | Value |
|---|---|
| Backend | AzureRM |
| Resource Group | `tf-auto-rg` |
| Storage Account | `terrautotfstate` |
| Container | `tfazdevops` |
| State Key | `terraform.tfstate` |

### Backend configuration

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "tf-auto-rg"
    storage_account_name = "terrautotfstate"
    container_name       = "tfazdevops"
    key                  = "terraform.tfstate"

    use_azuread_auth = true
  }
}
```

**Benefits:**
- Centralized remote state management.
- State locking to help prevent concurrent modifications.
- Shared state between local Terraform and Azure DevOps.
- Azure AD authentication for state access.

## 7. Azure DevOps CI/CD Pipeline

The project uses a four-stage Azure DevOps pipeline.

### Stage 1 – Terraform CI

- Install Terraform.
- Initialize Terraform backend.
- Check Terraform formatting.
- Validate Terraform configuration.
- Generate Terraform execution plan.
- Publish Terraform plan artifact.

### Stage 2 – Terraform CD

- Download Terraform plan artifact.
- Initialize Terraform backend and providers.
- Display the saved Terraform plan for review.

### Stage 3 – Manual Approval

- Wait for manual deployment approval.
- Review proposed infrastructure changes.
- Prevent unexpected deployments.

### Stage 4 – Terraform Apply

- Download the saved Terraform plan.
- Authenticate to Azure using OIDC.
- Initialize Terraform backend.
- Apply the approved Terraform plan.
- Deploy infrastructure changes.

## 8. Secure Authentication and Best Practices

The project implements the following security practices:

- Azure Workload Identity Federation (OIDC).
- No hardcoded Azure client secrets in pipeline YAML.
- Azure RBAC-based access control.
- Storage Blob Data Contributor permission for remote state.
- HTTPS-only storage traffic.
- TLS 1.2 minimum.
- Private storage container.
- Disabled public nested storage items.
- Terraform state and plan files excluded from Git.
- Manual approval before deployment.

The Azure DevOps service connection is named:

`Azure-Terraform-OIDC`

## 9. Prerequisites

- Active Microsoft Azure subscription.
- Azure DevOps organization and project.
- GitHub account.
- Terraform CLI 1.9.8.
- Azure CLI.
- Git.
- Visual Studio Code (recommended).

## 10. Local Deployment Instructions

### Step 1 – Clone the repository

```bash
git clone https://github.com/parikiharish/Azure-DevOps-Terraform.git
cd Azure-DevOps-Terraform
```

### Step 2 – Authenticate with Azure

```bash
az login
```

Select the appropriate subscription:

```bash
az account set --subscription "<YOUR_SUBSCRIPTION_ID>"
```

### Step 3 – Navigate to Terraform directory

```bash
cd terraform
```

### Step 4 – Initialize Terraform

```bash
terraform init
```

If the backend configuration has changed and the existing remote state should be retained without migration:

```bash
terraform init -reconfigure
```

### Step 5 – Format and validate

```bash
terraform fmt -check -recursive
terraform validate
```

### Step 6 – Generate Terraform plan

```bash
terraform plan
```

### Step 7 – Apply infrastructure changes

```bash
terraform apply
```

Review the proposed changes before confirming.

## 11. Deployment Validation

The Azure DevOps CI/CD deployment was successfully executed.

### Final Terraform Apply result

```text
Apply complete!
Resources: 0 added, 1 changed, 0 destroyed.
```

### Final local Terraform plan result

```text
No changes. Your infrastructure matches
the configuration.
```

These results confirm that the deployed Azure infrastructure matches the Terraform configuration after deployment.

## 12. Project Screenshots

### Azure DevOps CI/CD Pipeline

![Successful Azure DevOps Pipeline](screenshots/pipeline-success.png)

### Azure Infrastructure

![Azure Resources](screenshots/azure-resources.png)

### Manual Approval

![Terraform Manual Approval](screenshots/manual-approval.png)

### Terraform Plan Validation

![Terraform Plan](screenshots/terraform-plan.png)

## 13. Future Enhancements

Potential improvements:

- Separate development, staging, and production environments.
- Terraform security scanning using Checkov or tfsec.
- Azure Key Vault integration.
- Automated policy validation.
- Terraform test automation.
- Monitoring and alerting integration.
- Environment-specific approval gates.

## 14. Repository

**GitHub:**  
https://github.com/parikiharish/Azure-DevOps-Terraform

## Author

**Harish Pariki**

Azure DevOps | Terraform | Microsoft Azure | CI/CD | Infrastructure as Code

*This project demonstrates practical experience in Azure infrastructure automation, reusable Terraform modules, secure cloud authentication, remote state management, and automated CI/CD deployment.*
