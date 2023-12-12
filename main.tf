terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

resource "github_repository" "this" {
  name        = var.name
  description = var.description
  visibility  = var.private ? "private" : "public"

  has_issues      = false
  has_discussions = false
  has_wiki        = false

  # merge settings
  allow_merge_commit     = true
  merge_commit_title     = "PR_TITLE"
  merge_commit_message   = "PR_BODY"
  allow_squash_merge     = false
  allow_rebase_merge     = false
  allow_auto_merge       = true
  delete_branch_on_merge = true

  gitignore_template = var.gitignore_template
  topics             = var.topics
}

resource "github_branch_default" "this" {
  repository = github_repository.this.name
  branch     = var.default_branch
}

resource "github_branch_protection_v3" "this" {
  repository = github_repository.this.name
  branch     = github_branch_default.this.branch

  required_status_checks {
    strict = true
  }
  required_pull_request_reviews {
    dismiss_stale_reviews      = true
    require_code_owner_reviews = true
  }
}

resource "github_repository_collaborator" "pull" {
  for_each   = var.pull_collaborators
  repository = github_repository.this.name
  username   = each.value
  permission = "pull"
}

resource "github_repository_collaborator" "push" {
  for_each   = var.push_collaborators
  repository = github_repository.this.name
  username   = each.value
  permission = "push"
}

resource "github_repository_collaborator" "maintain" {
  for_each   = var.maintain_collaborators
  repository = github_repository.this.name
  username   = each.value
  permission = "maintain"
}

resource "github_repository_collaborator" "triage" {
  for_each   = var.triage_collaborators
  repository = github_repository.this.name
  username   = each.value
  permission = "triage"
}

resource "github_repository_collaborator" "admin" {
  for_each   = var.admin_collaborators
  repository = github_repository.this.name
  username   = each.value
  permission = "admin"
}

resource "github_repository_environment" "this" {
  for_each = var.environments

  environment = each.key
  repository  = github_repository.this.name
  deployment_branch_policy {
    protected_branches     = true
    custom_branch_policies = true
  }
}

resource "github_repository_environment_deployment_policy" "this" {
  for_each = {
    for env_name, env in var.environments : env_name => env.deployment_policy
  }

  repository     = github_repository.this.name
  environment    = github_repository_environment.this[each.key].environment
  branch_pattern = each.value.branch_pattern
}

resource "github_actions_environment_secret" "this" {
  # This for_each has to be marked as nonsensitive because a secret's plaintext
  # value is sensitive, which leads Terraform to conclude the for_each is
  # dangerous because it contains sensitive information. However, the only part
  # of the for_each that cannot be sensitive is the key (as described in
  # https://support.hashicorp.com/hc/en-us/articles/4538432032787-Variable-has-a-sensitive-value-and-cannot-be-used-as-for-each-arguments),
  # and an index is the key here, which is not sensitive.
  #
  # The inner sensitive() call is a temporary work-around while v1.7 of
  # Terraform remains unreleased. It handles the case where there are no
  # secrets, which means env.secrets (below) is simply {}, which is obviously
  # not sensitive and therefore causes pre-v1.7 Terraform to complain with
  # the following error:
  # ```
  # while calling nonsensitive(value)
  # <snip> is empty set of object
  # Invalid value for "value" parameter: the given value is not sensitive, so this call is redundant.
  # ```
  # See https://github.com/hashicorp/terraform/pull/33856 for more info.
  #
  # Also note it's acceptable to use the plaintext_value argument because of
  # https://github.com/integrations/terraform-provider-github/issues/888#issuecomment-1033059463.
  for_each = nonsensitive(sensitive({
    for idx, secret in flatten([
      for env_name, env in var.environments : [
        for secret in env.secrets : {
          environment  = env_name
          secret_name  = secret.name
          secret_value = secret.plaintext_value
        }
      ]
    ]) : idx => secret
  }))

  repository      = github_repository.this.name
  environment     = each.value.environment
  secret_name     = each.value.secret_name
  plaintext_value = each.value.secret_value
}

resource "github_actions_environment_variable" "this" {
  for_each = {
    for idx, variable in flatten([
      for env_name, env in var.environments : [
        for variable in env.variables : {
          environment    = env_name
          variable_name  = variable.name
          variable_value = variable.value
        }
      ]
    ]) : idx => variable
  }

  repository    = github_repository.this.name
  environment   = each.value.environment
  variable_name = each.value.variable_name
  value         = each.value.variable_value
}

resource "github_actions_repository_access_level" "this" {
  repository   = github_repository.this.name
  access_level = var.gha_access_level
}
