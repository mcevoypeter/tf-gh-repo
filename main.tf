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
