output "name" {
  value = var.name
}

output "fqdn" {
  value = aws_route53_record.subdomain_root.fqdn
}
