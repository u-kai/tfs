output "app_repo_url" {
  value = aws_ecr_repository.app_repo.repository_url
}

output "service_a_repo" {
  value = aws_ecr_repository.service_a_repo.repository_url
}

output "service_b_repo" {
  value = aws_ecr_repository.service_b_repo.repository_url
}
