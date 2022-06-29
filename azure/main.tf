variable "group_name" {
    type = string
}

provider "azurerm" {
  features {}
}

resource "random_id" "value" {
  byte_length = 3
}

locals {
   template_file_int  = templatefile("./install.tpl", {})
}

resource "azurerm_resource_group" "example" {
  name     = "${var.group_name}-rg-${random_id.value.id}"
  location = "westus3"
}

module "linuxservers" {
  source              = "Azure/compute/azurerm"
  resource_group_name = azurerm_resource_group.example.name
  vm_os_simple        = "UbuntuServer"
  #public_ip_dns       = ["linsimplevmips"] // change to a unique name per datacenter region
  vnet_subnet_id      = module.network.vnet_subnets[0]
  storage_account_type = "Standard_LRS"
  remote_port          = "22"
  custom_data          = local.template_file_int

  depends_on = [azurerm_resource_group.example]
}

module "network" {
  source              = "Azure/network/azurerm"
  resource_group_name = azurerm_resource_group.example.name
  subnet_prefixes     = ["10.0.1.0/24"]
  subnet_names        = ["subnet1"]

  depends_on = [azurerm_resource_group.example]
}

output "linux_vm_public_name" {
  value = module.linuxservers.public_ip_address
}
