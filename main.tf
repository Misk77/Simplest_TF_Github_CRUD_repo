# Provider

provider "github" {
  token        = var.token
  organization = var.organization
  version      = "~>2.3"
}

# Add member to org
resource "github_membership" "add_member" {
  username = "michelskoglund"
  role     = "member"
}

# Create Team
resource "github_team" "create_team" {
  name        = "My_Name_Of_The_Team"
  description = "we created a team"
  privacy     = "closed"
}

# Updating a team
resource "github_team_membership" "update_the_team" {
  count    = length(var.team_members)
  team_id  = github_team.create_team.id
  username = element(var.team_members, count.index)
  role     = "maintainer"
}

# create repo/Managing repo
resource "github_repository" "my_terraform_repo_maker" {
  name         = "repo_made_by_terraform"
  description  = "This repo is made by terraform "
  homepage_url = "michelskoglund.online"
  private      = "false"



}
