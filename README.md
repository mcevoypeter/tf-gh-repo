# [GitHub] Repository

This [Terraform] module creates a [GitHub] repository with opinions on the development workflow, which are described below.

## Branch Protections

The default branch is protected. Pull requests that target the default branch must be up-to-date before merging, and those pull requests must receive an approving review from a [codeowner][gh-codeowners]. A pull request's approving reviews are dismissed each time a new commit is pushed.

## Merge Settings

Merge commits are the only allowed form of merge; squash merges and rebase merges are both disallowed. The merge commit title and message are set to the corresponding pull request title and body, respectively.

## Environments

Zero or more environments may be specified with accompanying [GitHub Actions] secrets and variables. Only protected branches that match the environment's deployment policy may deploy to the environment.

## Issues

Repository issues are turned off.

## Wiki

The repository wiki is turned off.

## License

This project is licensed under the terms of the [MIT license](https://en.wikipedia.org/wiki/MIT_License).

[gh-codeowners]: https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners
[GitHub]: https://github.com
[GitHub Actions]: https://docs.github.com/en/actions
[Terraform]: https://www.terraform.io
