/**
 * [![Build Status](https://jenkins-terraform.mesosphere.com/service/dcos-terraform-jenkins/buildStatus/icon?job=dcos-terraform%2Fterraform-azurerm-lb-masters-internal%2Fsupport%252F0.2.x)](https://jenkins-terraform.mesosphere.com/service/dcos-terraform-jenkins/job/dcos-terraform/job/terraform-azurerm-lb-masters-internal/job/support%252F0.2.x/)
 *
 * Azure LB Masters Internal
 * ============
 * This module create a load balancer for cluster internal access to masters
 *
 * EXAMPLE
 * -------
 *
 *```hcl
 * module "lb-masters-internal" {
 *   source  = "dcos-terraform/lb-masters-internal/azurerm"
 *   version = "~> 0.2.0"
 *
 *   cluster_name = "production"
 *
 *   location            = ["North Europe"]
 *   resource_group_name = "my-resource-group"
 *   subnet_id           = "subnet/id/the/load-balancer/should/be/in"
 * }
 *```
 */

provider "azurerm" {}

module "masters-internal" {
  source  = "dcos-terraform/lb/azurerm"
  version = "~> 0.2.0"

  cluster_name = "${var.cluster_name}"
  name_prefix  = "${var.name_prefix}"

  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  instance_nic_ids = ["${var.instance_nic_ids}"]
  hostname_format  = "${var.hostname_format}"

  lb_name_format = "int-%[1]s"

  providers = {
    azurerm = "azurerm"
  }

  additional_rules = [
    {
      frontend_port = 5050
    },
    {
      frontend_port = 2181
    },
    {
      frontend_port = 8181
    },
    {
      frontend_port = 8080
    },
  ]

  probe {
    port = 5050
  }

  internal  = true
  subnet_id = "${var.subnet_id}"

  num = "${var.num}"

  tags = "${var.tags}"
}
