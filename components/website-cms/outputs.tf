output "db_host" {
  value = aws_db_instance.website-cms-database.address
}

output "ip" {
  value = aws_eip.website-cms.public_ip
}