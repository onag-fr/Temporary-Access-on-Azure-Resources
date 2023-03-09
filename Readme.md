Sometimes developers need to access temporarily to Azure resources for troubleshooting purposes or just for the fun ;) but they don't have always access on Azure to proceed by themselves.
That's why I thought to afford them autonomy through Azure DevOps.

Of course these pipelines/scripts can be adapted to answer your own context with different Azure services like Key Vault, Storage Account, Database, ...

# Azure DevOps pipelines
Of course, these access, must be temporary, that's why I create:
- One pipeline to allow developers to add their public Ip on Azure resources
- One pipeline to remove automatically these access each day

**In our example, the target Azure resource is an App Service, and we add/remove access on Kudu portal.**

## Add IP to Kudu
The goal of that Pipeline, based on the **allow_ips.yml** file is to allow developers to add their public IP on Kudu for different environments like DEV, TST or UAT ones. 


| **Application** | **Environment** | **Region** | **Resource Group** | **App Service** | **Variable Group** |
|--|--|--|--|--|--|
| MyApp | DEV | North Europe - EU | MYAPPLICATION-DEV-EU-RG01 | MyAppService1 | var-devops-app1-dev-eu |
| MyApp | TST | North Europe - EU | MYAPPLICATION-TST-EU-RG01 | MyAppService2 | var-devops-app1-tst-eu |
| MyApp | UAT | North Europe - EU | MYAPPLICATION-UAT-EU-RG01 | MyAppService3 | var-devops-app1-uat-eu |
| MyApp | UAT | East US 2 - US | MYAPPLICATION-UAT-US-RG01 | MyAppService4 | var-devops-app1-uat-us |
| MyApp | UAT | Australia East - AU | MYAPPLICATION-UAT-AU-RG01 | MyAppService5 | var-devops-app1-uat-au |

To easily managed the Azure resources in Azure DevOps, we decided to create a varibale group per environment with information like!
- Environment
- ResourceGroupName
- AppServiceName

## Remove IP from Kudu
As mentionned previsouly, these access are temporary, so we created another Pipeline that will be triggered every day at a specific time to remove the IP on Kudu.

---------

# How to

## Sources
All the content used for these pipelines are stored into this repository.

## Process to add your IP
1. First step is to add your public Ip that you can get [here](http://monip.org/), into the [dev_team_ips.txt]() file combined with **/32**:
Example: **11.22.33.44/32**
1. Launch the first Pipeline by selecting your environment and the region
1. You should be able to connect on the App Service through Kudu

## Process to remove your IP
Two ways to proceed:
1. Launch manually the pipeline to remove the IP
1. Wait until the configured hour that will automatically trigger the pipeline to remove the IP without any human intervention