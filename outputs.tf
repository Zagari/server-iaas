
output "public_ip" {
  value       = aws_eip.castellabate_ip.public_ip
  description = "IP público da instância EC2"
}

output "instance_id" {
  value = aws_instance.castellabate.id
}
