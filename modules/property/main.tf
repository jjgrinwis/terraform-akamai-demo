# this module will create a property but won't activate it
# it will ouput the property_id, dv_list and latest version
terraform {
  required_providers {
    akamai = {
      source  = "akamai/akamai"
      version = "1.9.1"
    }
  }
}

locals {
  # using ION as our default product in case wrong product type has been provided as input var.
  default_product = "prd_Fresca"

  # just store our rules.json in root module .terraform dir
  rules = ".terraform/rules.json"

  # check if we're managing this from Akamai Control Center (ACC) or from local template directory
  # if you are using ACC then file and bool should be set!
  # initial rules will always be created from template directory.
  acc_managed = fileexists(local.rules) && var.acc_managed
}

# just use group_name to lookup our contract_id and group_id
# this will simplify our variables file as this contains contract and group id
# use "akamai property groups list" to find all your groups 
data "akamai_contract" "contract" {
  group_name = var.group_name
}

# let try to create a new cpcode. If it already exists the existing one will be used.
# after cpcode has been created you can't modify or delete it!
resource "akamai_cp_code" "cp_code" {
  name        = var.cpcode
  contract_id = data.akamai_contract.contract.id
  group_id    = data.akamai_contract.contract.group_id
  product_id  = lookup(var.aka_products, lower(var.product_name), local.default_product)
}

data "akamai_property_rules_template" "aka_initial_rules" {
  # we only need to create this data resource if it's our initial setup
  count = local.acc_managed ? 0 : 1
  # template created via 'akamai terraform create-property <template in acc>'
  # remove the .tf files and add vars to property-snippets/*.json files
  # template is based on the Akamai product selected ion, dsa
  template_file = "template/property-snippets/main.json"
  variables {
    name  = "origin"
    value = var.origin
    type  = "string"
  }
  variables {
    name  = "cpcode"
    value = trimprefix(resource.akamai_cp_code.cp_code.id, "cpc_")
    type  = "number"
  }
}

# lookup our active property
# only when we're mananaging it from ACC and .rules/rules.json exists we need this lookup
# it will fail if property doesn't exists
data "akamai_property" "aka_active" {
  # we only need to check this one if it exists
  count = local.acc_managed ? 1 : 0
  name  = var.hostnames[0]
}

# only lookup rules if we have an active property.id
data "akamai_property_rules" "aka_active_rules" {
  count       = local.acc_managed ? 1 : 0
  property_id = data.akamai_property.aka_active[0].id
  contract_id = data.akamai_contract.contract.id
  group_id    = data.akamai_contract.contract.group_id
}

# create our edge hostname resource
resource "akamai_edge_hostname" "aka_edge" {
  product_id  = lookup(var.aka_products, lower(var.product_name), local.default_product)
  contract_id = data.akamai_contract.contract.id
  group_id    = data.akamai_contract.contract.group_id
  ip_behavior = var.ip_behavior

  # when using edgekey.net(eTLS) as edgehostname the certificate should already be requested!
  # you need a certificate enrollment_id which is available via "akamai cps list"
  # only when it's CPS managed with edgesuite.net we need enrollment_id but looks like we have a bug as terraform won't allow it.
  # adding a ennrollment_id with DEFAULT shouldn't be possible.
  certificate = var.domain_suffix == "edgekey.net" ? var.enrollment_id : null

  # use the first item in your list to be used as the edgehostname
  edge_hostname = "${var.hostnames[0]}.${var.domain_suffix}"
}

# create a property resource with json rules from active rules or template dir.
resource "akamai_property" "aka_property" {
  name        = var.hostnames[0]
  contract_id = data.akamai_contract.contract.id
  group_id    = data.akamai_contract.contract.group_id
  product_id  = lookup(var.aka_products, var.product_name, local.default_product)

  # create a dynamic hostnames resource block for our different hostnames 
  # hostnames are coming from our list of hostnames variable
  dynamic "hostnames" {
    for_each = toset(var.hostnames)
    content {
      cname_from             = hostnames.value
      cname_to               = resource.akamai_edge_hostname.aka_edge.edge_hostname
      cert_provisioning_type = var.cert_provisioning_type
    }
  }
  # based on where you manage your rules it either update from the active rules in ACC or created from template dir
  rules = local.acc_managed ? data.akamai_property_rules.aka_active_rules[0].rules : data.akamai_property_rules_template.aka_initial_rules[0].json
}

# now write our rules back to the local.rules directory
resource "local_file" "rules_json" {
  content  = local.acc_managed ? data.akamai_property_rules.aka_active_rules[0].rules : data.akamai_property_rules_template.aka_initial_rules[0].json
  filename = local.rules

  # if anything goes wrong don't update the rules file
  depends_on = [
    resource.akamai_property.aka_property
  ]
}
