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
