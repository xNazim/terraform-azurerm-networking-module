resource "azurerm_virtual_network" "vnet" {
  name                = "${var.name-prefix}-vnet"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_space
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.address_prefixes

}

resource "azurerm_network_security_group" "nsg" {
  name                = "${(var.name-prefix)}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic "security_rule" {
    for_each = var.rules
    content {
      name                       = security_rule.value["name"]
      priority                   = security_rule.value["priority"]
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value["destination_port_range"]
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
}

resource "azurerm_public_ip" "p-ip" {
  name                = "${var.name-prefix}-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label = "${var.name-prefix}-2142134-dns.com"
}

resource "azurerm_lb" "lb-vmss" {
  name                = "${var.name-prefix}-lb"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.p-ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "backend-pool" {
  loadbalancer_id = azurerm_lb.lb-vmss.id
  name            = "${var.name-prefix}BackEndAddressPool"
}


resource "azurerm_lb_nat_pool" "nat-pool" {
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.lb-vmss.id
  name                           = "${var.name-prefix}-natpool"
  protocol                       = "Tcp"
  frontend_port_start            = 50000
  frontend_port_end              = 50001
  backend_port                   = 22
  frontend_ip_configuration_name = "PublicIPAddress"
}



resource "azurerm_lb_probe" "lb-probe" {
  loadbalancer_id = azurerm_lb.lb-vmss.id
  name            = "${var.name-prefix}-http-probe"
  protocol        = "Http"
  port            = 80
  request_path    = "/"
}


resource "azurerm_lb_rule" "lb-rule" {
  loadbalancer_id                = azurerm_lb.lb-vmss.id
  name                           = "${var.name-prefix}-LBRule"
  protocol                       = "Tcp"
  backend_port                   = 80
  frontend_port                  = 80
  probe_id                       = azurerm_lb_probe.lb-probe.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend-pool.id]
  frontend_ip_configuration_name = "PublicIPAddress"
}




