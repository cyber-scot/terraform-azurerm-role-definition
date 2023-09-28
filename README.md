
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

  scope                = each.value.assignment_scope
  role_definition_name = azurerm_role_definition.custom[each.key].name
  principal_id         = each.value.principal_id
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
| <a name="input_roles"></a> [roles](#input\_roles) | The roles to be created and optionally assigned | <pre>list(object({<br>    create_role      = bool<br>    assign           = optional(bool)<br>    name             = string<br>    description      = string<br>    definition_scope = string<br>    principal_id     = string<br>    permissions = list(object({<br>      actions          = list(string)<br>      not_actions      = optional(list(string))<br>      data_actions     = optional(list(string))<br>      not_data_actions = optional(list(string))<br>    }))<br>    assignment_scope = string<br>    built_in_role_id = optional(string)<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_role_assignments"></a> [role\_assignments](#output\_role\_assignments) | Map of created custom role assignments. |
| <a name="output_role_definitions"></a> [role\_definitions](#output\_role\_definitions) | Map of created custom role definitions. |
