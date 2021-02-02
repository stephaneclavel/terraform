module "repository" {
  source  = "mineiros-io/repository/github"
  version = "~> 0.6.0"

  name               = var.name
  description        = var.description
  homepage_url       = var.homepage_url
  private            = false
  has_issues         = true
  has_projects       = false
  has_wiki           = false
  allow_merge_commit = true
  allow_rebase_merge = false
  allow_squash_merge = false
  has_downloads      = false
  auto_init          = true
  gitignore_template = var.gitignore_template
  license_template   = var.license_template
  topics             = var.topics

  admin_collaborators = var.admin_collaborators

}
