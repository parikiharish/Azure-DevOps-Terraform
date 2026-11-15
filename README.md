Azure Infrastructure Automation using Terraform & Azure DevOps

## Project Overview

This project demonstrates automated Azure infrastructure provisioning using **Terraform** and **Azure DevOps CI/CD pipelines**.

The infrastructure is deployed using reusable Terraform modules, while Azure Blob Storage maintains the remote Terraform state.

Azure DevOps automates the infrastructure deployment workflow with Workload Identity Federation (OIDC), Terraform validation, planning, manual approval, and deployment.

The objective is to demonstrate a secure, reusable, and automated Infrastructure as Code (IaC) implementation following DevOps best practices.

## Architecture

### High-Level Workflow

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
    Azure OIDC Login
           |
           v
    Terraform Init
           |
           v
   Terraform Validate
           |
           v
     Terraform Plan
           |
           v
   Publish Plan Artifact
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
           +----------------------+
           |                      |
           v                      v
    Azure Resources        Azure Blob Storage
                           (Remote Terraform
                                State)
```

## Technologies Used

| Technology | Purpose |
|---|---|
| Microsoft Azure | Cloud infrastructure |
| Terraform 1.9.8 | Infrastructure as Code |
| Azure DevOps | CI/CD automation |
| GitHub | Source code management |
| Azure Blob Storage | Remote Terraform state |
| Workload Identity Federation | Secretless Azure authentication |
| YAML | Pipeline configuration |
| PowerShell | Local administration |

## Azure Infrastructure

The project provisions the following Azure resources:

- Azure Resource Group
- Azure Virtual Network
- Azure Subnet
- Network Security Group (NSG)
- NSG Security Rules
- Subnet and NSG Association
- Azure Storage Account
- Private Storage Container

### Network Configuration

| Component | Configuration |
|---|---|
| Resource Group | `rg-dev` |
| Location | East US |
| Virtual Network | `vnet-dev` |
| Address Space | `10.0.0.0/16` |
| Subnet | `subnet-dev-web` |
| Subnet CIDR | `10.0.1.0/24` |
| Network Security Group | `nsg-dev-web` |
| HTTP | TCP 80 |
| HTTPS | TCP 443 |

SSH and RDP inbound rules are excluded from the current configuration.

## Terraform Project Structure

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
├── azure-pipelines.yml
├── README.md
└── .gitignore
```

### Terraform Modules

Each module manages a specific Azure infrastructure component.

- **Resource Group:** Creates and manages the Azure Resource Group.
- **Network:** Creates the Virtual Network.
- **Subnet:** Creates the application subnet.
- **NSG:** Creates the Network Security Group and security rules.
- **NSG Association:** Associates the NSG with the subnet.
- **Storage:** Creates the Azure Storage Account and private container.

## Remote Terraform State Management

Terraform state is stored remotely using Azure Blob Storage.

| Setting | Value |
|---|---|
| Resource Group | `tf-auto-rg` |
| Storage Account | `terrautotfstate` |
| Container | `tfazdevops` |
| State File | `terraform.tfstate` |

### Backend Configuration

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

Benefits:

- Centralized Terraform state management.
- State locking to prevent concurrent modifications.
- Secure state access using Azure AD authentication.
- Shared state between local Terraform and Azure DevOps.

## Azure DevOps CI/CD Pipeline

The project implements a four-stage Azure DevOps pipeline.

### Stage 1: Continuous Integration (CI)

- Install Terraform.
- Initialize Terraform backend.
- Check Terraform formatting.
- Validate Terraform configuration.
- Generate Terraform execution plan.
- Publish the Terraform plan artifact.

### Stage 2: Continuous Delivery (CD)

- Download the Terraform plan artifact.
- Initialize Terraform backend and providers.
- Display the saved Terraform execution plan for review.

### Stage 3: Manual Approval

- Wait for manual approval.
- Review proposed infrastructure changes.
- Prevent unexpected deployments.

### Stage 4: Terraform Apply

- Download the approved Terraform plan.
- Authenticate to Azure using OIDC.
- Initialize the remote backend.
- Apply the approved Terraform plan.
- Deploy the infrastructure changes.

## Security Best Practices

This project implements the following security measures:

- Azure Workload Identity Federation (OIDC).
- No hardcoded Azure client secrets in pipeline YAML.
- Azure RBAC-based access control.
- Storage Blob Data Contributor permission for remote state access.
- HTTPS-only Storage Account traffic.
- TLS 1.2 minimum.
- Private storage container.
- Disabled public nested storage items.
- Terraform state and plan files excluded from Git.
- Manual approval before infrastructure deployment.

## Prerequisites

Before deploying the project, ensure you have:

1. An active Microsoft Azure subscription.
2. An Azure DevOps organization and project.
3. A GitHub account.
4. Terraform CLI version 1.9.8.
5. Azure CLI.
6. Git.
7. VS Code (recommended).

## Local Deployment Instructions

### Step 1: Clone the repository

```bash
git clone https://github.com/parikiharish/Azure-DevOps-Terraform.git
```

```bash
cd Azure-DevOps-Terraform/terraform
```

### Step 2: Authenticate with Azure

```bash
az login
```

Select the correct Azure subscription:

```bash
az account set --subscription "<YOUR_SUBSCRIPTION_ID>"
```

### Step 3: Initialize Terraform

```bash
terraform init
```

If the backend configuration has intentionally changed and you want to reconnect without migrating state:

```bash
terraform init -reconfigure
```

### Step 4: Validate Terraform

```bash
terraform fmt -check -recursive
terraform validate
```

### Step 5: Generate Terraform Plan

```bash
terraform plan
```

### Step 6: Apply Infrastructure Changes

```bash
terraform apply
```

Review the proposed changes before confirming.

## Azure DevOps Configuration

1. Create an Azure Resource Manager service connection.
2. Configure Workload Identity Federation.
3. Assign the required Azure RBAC permissions.
4. Connect the GitHub repository to Azure Pipelines.
5. Select the existing `azure-pipelines.yml`.
6. Configure pipeline authorization for the service connection.
7. Run the pipeline and review the Terraform plan.
8. Approve the deployment at the manual approval stage.

The service connection used in this project is:

`Azure-Terraform-OIDC`

## Deployment Validation

The infrastructure deployment was successfully tested.

The final Terraform Apply result was:

```text
Apply complete!
Resources: 0 added, 1 changed, 0 destroyed.
```

The subsequent local Terraform plan returned:

```text
No changes. Your infrastructure matches
the configuration.
```

This confirms that the local Terraform configuration and deployed Azure infrastructure are synchronized.

## Future Enhancements

Potential improvements for future iterations:

- Separate development, staging, and production environments.
- Terraform security scanning using Checkov or tfsec.
- Azure Key Vault integration.
- Automated policy validation.
- Terraform test automation.
- Monitoring and alerting integration.
- Environment-specific approval gates.

## Author

**Harish Pariki**

Azure DevOps | Terraform | Microsoft Azure | CI/CD | Infrastructure as Code

GitHub: https://github.com/parikiharish

---

*This project is developed as a practical demonstration of Azure infrastructure automation, Terraform modularization, secure authentication, and CI/CD deployment practices.*
