output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}
output "subnet_id" {
  value = azurerm_subnet.subnet.id
}

output "nsg_id" {
  value = azurerm_network_security_group.nsg.id
}

output "backend_pool_id" {
  value = azurerm_lb_backend_address_pool.backend-pool.id
}

output "nat_pool_id" {
  value = azurerm_lb_nat_pool.nat-pool.id
}

output "public_ip" {
  value = azurerm_public_ip.p-ip
}

output "fqdn" {
  value = "${azurerm_public_ip.p-ip.domain_name_label}.${var.location}.cloudapp.azure.com"
}