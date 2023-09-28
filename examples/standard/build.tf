module "rg" {
  source = "cyber-scot/rg/azurerm"

  name     = "rg-${var.short}-${var.loc}-${var.env}-01"
  location = local.location
  tags     = local.tags
}

resource "azurerm_user_assigned_identity" "uaid" {
  resource_group_name = module.rg.rg_name
  location            = module.rg.rg_location
  tags                = module.rg.rg_tags

  name = "id-${var.short}-${var.loc}-${var.env}-build"
}

module "custom_role_definition" {
  source = "cyber-scot/role-definition/azurerm"

  roles = [
    {
      create_role      = true
      assign           = true
      name             = "CustomRole1"
      description      = "This is a custom role 1"
      definition_scope = format("/subscriptions/%s", data.azurerm_client_config.current.subscription_id)
      principal_id     = azurerm_user_assigned_identity.uaid.principal_id
      permissions = [
        {
          actions          = ["Microsoft.Authorization/*/read"]
          not_actions      = []
          data_actions     = []
          not_data_actions = []
        }
      ]
      assignment_scope = module.rg.rg_id
    },
  ]
}
