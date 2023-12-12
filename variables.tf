variable "name" {
  description = "Name of the repository."
  type        = string
}

variable "description" {
  description = "Description of the repository."
  type        = string
  default     = ""
}

variable "private" {
  description = "True if the repository is private."
  type        = bool
  default     = true
}

variable "default_branch" {
  description = "Name of the repository's default branch."
  type        = string
  default     = "main"
}

variable "gitignore_template" {
  description = "Name of template from https://github.com/github/gitignore without the extension"
  type        = string
  default     = ""
}

variable "topics" {
  description = "Topics to tag the repository with"
  type        = set(string)
  default     = []
}

variable "pull_collaborators" {
  description = "Collaborators with pull access to the repository"
  type        = set(string)
  default     = []
}

variable "push_collaborators" {
  description = "Collaborators with push access to the repository"
  type        = set(string)
  default     = []
}

variable "maintain_collaborators" {
  description = "Collaborators with maintain access to the repository"
  type        = set(string)
  default     = []
}

variable "triage_collaborators" {
  description = "Collaborators with triage access to the repository"
  type        = set(string)
  default     = []
}

variable "admin_collaborators" {
  description = "Collaborators with admin access to the repository"
  type        = set(string)
  default     = []
}
