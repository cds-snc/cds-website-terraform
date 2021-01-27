output "db_host" {
  value = aws_db_instance.website-cms-database.endpoint
}

output "ip" {
  value = aws_eip.website-cms[0].public_ip
}