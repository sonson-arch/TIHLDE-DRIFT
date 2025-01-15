# TIHLDE-DRIFT
Oppsett ved hjelp av Terraform



## Implentering av Terraform kode 
1. Lag et directory hvor du tester og kjører Terraform koden og gjør den til current directory.

2. Lag en fil som heter `providers.tf` og sett inn følgende kode:

```hcl
#Configure the Azure provider
terraform {
  required_version = ">=1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}
provider "azurerm" {
  features {}
}
```

3. Lag en fil kalt `main.tf`og legg inn følgende kode: 
```hcl
resource "azurerm_resource_group" "rg" {
  name     = "database-rg-test-tihlde-drift"  # Ensure this name remains unchanged
  location = var.resource_group_location
}

resource "random_password" "password" {
  count       = var.admin_password == null ? 1 : 0
  length      = 20
  special     = true
  min_numeric = 1
  min_upper   = 1
  min_lower   = 1
  min_special = 1
}

resource "random_id" "server_suffix" {
  byte_length = 4
}

locals {
  admin_password = try(random_password.password[0].result, var.admin_password)
}

resource "azurerm_mssql_server" "server" {
  name                         = "${var.resource_group_name_prefix}-sql-server-${random_id.server_suffix.hex}"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  administrator_login          = var.admin_username
  administrator_login_password = local.admin_password
  version                      = "12.0"
}

resource "azurerm_mssql_database" "db" {
  name      = var.sql_db_name
  server_id = azurerm_mssql_server.server.id
}
```


## Initialiser Terraform
Kjør kommandoen [terraform init](https://developer.hashicorp.com/terraform/cli/commands/init) for å intialisere Terraform deployering. Denne kommandoen laster ned Azure provideren nødvendig for å administrere Azure ressursene.
```hcl
terraform init -upgrade

```

## Lag en Terraform utførelsesplan 

Kjør kommandoen [terraform plan](https://www.terraform.io/docs/commands/plan.html) for å lage en utførelsesplan.

```hcl
terraform plan -out main.tfplan
```

## Kjør Terraform utførelsesplan

Bruk kommandoen [terraform apply](https://www.terraform.io/docs/commands/apply.html) for å kjøre utførelsesplanen på skyinfrastrukturen. 

```hcl
terraform apply main.tfplan
```

## Slett ressursene
Når du ikke lenger trenger ressursene, gjør følgende:

1. Kjør [terraform plan](https://www.terraform.io/docs/commands/plan.html) og spesifiser ```destroy``` flag.
```hcl
terraform plan -destroy -out main.destroy.tfplan
```
2. Bruk kommandoen [terraform apply](https://www.terraform.io/docs/commands/apply.html) for å kjøre utførelsesplanen.
```hcl
terraform apply main.destroy.tfplan
```