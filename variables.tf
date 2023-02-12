variable "mykey" {
  default = "nvirginia"
}

variable "myami" {
  default = "ami-026b57f3c383c2eec"
}

variable "instancetype" {
  default = "t3a.medium"
}

variable "tag" {
  default = "Jenkins"
}

variable "jenkins-sg" {
  default = "jenkins-sg"
}

variable "project_github_repo_name" {
  default = "Jenkins-project"
}

variable "github_username" {
  default = "ycetindil"
}