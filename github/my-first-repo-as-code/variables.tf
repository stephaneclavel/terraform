variable "name" {
  type        = string
  description = "repo name"
}

variable "description" {
  type        = string
  description = "repo description"
}

variable "homepage_url" {
  type        = string
  description = "github homepage url"
}

variable "gitignore_template" {
  type        = string
  description = ".gitignore file template"
}

variable "license_template" {
  type        = string
  description = "repository license template"
}

variable "topics" {
  type        = list(any)
  description = "list of topics"
}

variable "admin_collaborators" {
  type        = list(any)
  description = "list of collaborators with admin privilege"
}
