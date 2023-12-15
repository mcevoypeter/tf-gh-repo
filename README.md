# [GitHub] Repository

This [Terraform] module creates a [GitHub] repository with opinions on the development workflow, which are described below.

## Settings

### Branch Protections

The default branch is protected. Pull requests that target the default branch must be up-to-date before merging. A pull request's reviews are dismissed each time a new commit is pushed.

### Merge Settings

Merge commits are the only allowed form of merge; squash merges and rebase merges are both disallowed. The merge commit title and message are set to the corresponding pull request title and body, respectively.

### Environments

Zero or more environments may be specified with accompanying [GitHub Actions] secrets and variables. Only protected branches that match the environment's deployment policy may deploy to the environment.

### Issues

Repository issues are turned off.

### Wiki

The repository wiki is turned off.

## Example


```terraform
module "example_repo" {
  source             = "git@github.com:mcevoypeter/tf-gh-repo.git"
  name               = "example"
  description        = "This repo was created with the tf-gh-repo module"
  gitignore_template = "Go"
  topics = [
    "github",
    "github-actions",
    "terraform",
  ]
  admin_collaborators = ["mcevoypeter"]
  environments = {
    "testing" = {
      deployment_policy = { branch_pattern = "main" },
      secrets = [
        {
          name            = "SOME_SECRET",
          plaintext_value = "SOME_SECRET_VALUE",
        },
      ],
      variables = [
        {
          name  = "SOME_VARIABLE",
          value = "SOME_VARIABLE_VALUE",
        },
      ]
    }
  }
  gha_access_level = "user"
}
```

## License

This project is licensed under the terms of the [MIT license](https://en.wikipedia.org/wiki/MIT_License).

[GitHub]: https://github.com
[GitHub Actions]: https://docs.github.com/en/actions
[Terraform]: https://www.terraform.io
