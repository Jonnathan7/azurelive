locals {
    alias = "lovisa"
    #ejemplo, region = "East US 2"
    region = "East US 2"
    workers = 3
    instancia = "Standard_D1_v2"
    subscripcion = ""
    #az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<subscriptionID>/resourceGroups/<resourceGroupName>" 
    clientid = ""
    clientsecret = ""
}
