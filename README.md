Simplest TF-Github CRUD repo



Create PAT
We will do this in one file, but should be on separate files:

2. Specify provider: specify the provider and version and which ORG to point to
note: We keep the token and ORG name in terraform.tfvars  and set variable in variables.tf 

#create provider:

provider "github" {
  token = var.token
  organization = var.organization
  version = "~>2.3"
}



3. Initilizing the terraform  and verify that the expected version is used
$ terraform init
$ terraform version

4. Add member to ORG:  username and access role
note: if you do terraform destroy it will cancel the invitation to members
note: Any ORGANIZATIONAL settings will be applied to this invitation;  as example:  2-MFA will also be applied to this invitation if its mandatory in the ORG setting AND IF THEY(users) DON'T HAVE 2-MFA enabled,  they wont be able to join!!

resource "github_membership" "add_member" {
  username = "michelskoglund"
  role = "member"
}



5. Creating Teams: easier to maintain security and group user to specific repo and security settings

resource "github_team" "create_team" {
  name = "My_Name_Of_The_Team"
  description = "we created a team"
  privacy = "closed"
}


6. Updating a Team:  we updating the team above, so all member in this team will have role maintainer
note: only needed/mandotory is the attribut: name
note: count will go though a variable in variables.tf   , this is a list of name :       variable "team_members" { default =[ "michelskoglund"] }
note: team_id will use the id from creating teams step; all resources get an id, this isnt specified in the above code but it exist :   resource "github_team" "create_team" "id" in api calls its looks as:  github_team.create_team.id
note: username, (maybe should ""usernames") THIS  will go though all element in the list in counts, each name has it own index count number [0]  [1]...etc 
note: terraform destroy will not cancel/remove the user without the step 4 included in current code, should probably use same concept for adding members ()
resource "github_team_membership" "update_the_team" {
  count = length(var.team_members)
  team_id = github_team.create_team.id
  username = element(var.team_members, count.index)
  role = "maintainer"
}



7.. Create/Manging repo :  create a repo 
note: only needed/mandotory is the attribut: name
resource "github_repository" "my_terraform_repo_maker" {
  name = "repo_made_by_terraform"
  description = "This repo is made by terraform "
  homepage_url = "michelskoglund.online"
  private = "false"
}
# Simplest_TF_Github_CRUD_repo
