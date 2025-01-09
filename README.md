# TIHLDE-DRIFT
Oppsett av rg og db i Azure ved hjelp av Terraform

## Initialiser Terraform
Kjør kommandoen [terraform init](https://developer.hashicorp.com/terraform/cli/commands/init) for å intialisere Terraform deployering. Denne kommandoen laster ned Azure provideren nødvendig for å administrere Azure ressursene.
```HCL
terraform init -upgrade

```

## Lag en Terraform utførelsesplan 

Kjør kommandoen [terraform plan](https://www.terraform.io/docs/commands/plan.html) for å lage en utførelsesplan.

```HCL
terraform plan -out main.tfplan
```

## Kjør Terraform utførelsesplan

Bruk kommandoen [terraform apply](https://www.terraform.io/docs/commands/apply.html) for å kjøre utførelsesplanen på skyinfrastrukturen. 

```HCL
terraform apply main.tfplan
```

## Slett ressursene
Når du ikke lenger trenger ressursene, gjør følgende:

1. Kjør [terraform plan](https://www.terraform.io/docs/commands/plan.html) og spesifiser ```destroy``` flag.
```HCL
terraform plan -destroy -out main.destroy.tfplan
```
2. Bruk kommandoen [terraform apply](https://www.terraform.io/docs/commands/apply.html) for å kjøre utførelsesplanen.
```HCL
terraform apply main.destroy.tfplan
```
