
```hcl
resource "azurerm_role_definition" "custom" {
  for_each = { for role in var.roles : role.name => role if role.create_role }

  name        = each.value.name
  description = each.value.description
  scope       = each.value.definition_scope

  dynamic "permissions" {
    for_each = each.value.permissions
    content {
      actions          = lookup(permissions.value, "actions", [])
      not_actions      = lookup(permissions.value, "not_actions", [])
      data_actions     = lookup(permissions.value, "data_actions", [])
      not_data_actions = lookup(permissions.value, "not_data_actions", [])
    }
  }
}

resource "azurerm_role_assignment" "custom" {
  for_each = { for role in var.roles : role.name => role if lookup(role, "assign", true) }

  scope              = each.value.assignment_scope
  role_definition_name = azurerm_role_definition.custom[each.key].name
  principal_id       = each.value.principal_id
}
```
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_role_assignment.custom](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_definition.custom](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assignments"></a> [assignments](#input\_assignments) | List of role assignments | <pre>list(object({<br>    name                                   = optional(string)<br>    scope                                  = string<br>    role_definition_id                     = optional(string)<br>    role_definition_name                   = optional(string)<br>    principal_id                           = string<br>    condition                              = optional(string)<br>    condition_version                      = optional(string)<br>    delegated_managed_identity_resource_id = optional(string)<br>    description                            = optional(string)<br>    skip_service_principal_aad_check       = optional(bool)<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_role_assignments"></a> [role\_assignments](#output\_role\_assignments) | Map of created role assignments. |
