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
