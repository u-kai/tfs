resource "aws_ecr_repository" "app_repo" {
  name = "app-repo"
}

resource "aws_ecr_repository" "service_a_repo" {
  name = "service-a-repo"
}

resource "aws_ecr_repository" "service_b_repo" {
  name = "service-b-repo"
}



