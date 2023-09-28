output "role_assignments" {
  description = "Map of created custom role assignments."
  value = {
    for key, assignment in azurerm_role_assignment.custom :
    key => {
      id                 = assignment.id
      principal_id       = assignment.principal_id
      role_definition_id = assignment.role_definition_id
      scope              = assignment.scope
    }
  }
}

output "role_definitions" {
  description = "Map of created custom role definitions."
  value = {
    for key, definition in azurerm_role_definition.custom :
    key => {
      id          = definition.id
      name        = definition.name
      description = definition.description
      scope       = definition.scope
      permissions = [for permission in definition.permissions : {
        actions          = permission.actions
        not_actions      = permission.not_actions
        data_actions     = permission.data_actions
        not_data_actions = permission.not_data_actions
      }]
    }
  }
}
