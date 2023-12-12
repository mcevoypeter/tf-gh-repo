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

resource "github_actions_repository_access_level" "this" {
  repository   = github_repository.this.name
  access_level = var.gha_access_level
}
