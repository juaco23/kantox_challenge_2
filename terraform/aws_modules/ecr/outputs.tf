output "ecr_repository_arn" {
  value       = aws_ecr_repository.this.arn
  description = "Full ARN of the repository"
}
