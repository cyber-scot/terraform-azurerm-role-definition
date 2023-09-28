variable "roles" {
  description = "The roles to be created and optionally assigned"
  type = list(object({
    create_role      = bool
    assign           = optional(bool)
    name             = string
    description      = string
    definition_scope = string
    principal_id     = string
    permissions = list(object({
      actions          = list(string)
      not_actions      = optional(list(string))
      data_actions     = optional(list(string))
      not_data_actions = optional(list(string))
    }))
    assignment_scope = string
    built_in_role_id = optional(string)
  }))
  default = []
}
