# module: bastion

output "bastion_dns_record" {
  description = "The DNS record of the bastion"
  value = aws_route53_record.bastion[0].fqdn
}

output "private_key_pem" {
  description = "The private key pem"
  value = tls_private_key.key[0].private_key_pem
}

