
output "public_sg_id" {
  value       = aws_security_group.public_security_group.id
}

output "private_sg_id" {
  value       = aws_security_group.private_security_group.id
}

output "alb_sg_id" {
  value       = aws_security_group.alb_security_group.id
}