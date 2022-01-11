output "public_ip" {
  description = "Contains the public IP address"
  value       = aws_eip.eip.public_ip
}

output "private_ip" {
  description = "Private IP of instance"
  value       =  [aws_instance.instance.private_ip]
}

output "id" {
  description = "Disambiguated ID of the instance"
  value       = [aws_instance.instance.id]
}

output "ssh_key_pair" {
  description = "Name of the SSH key pair provisioned on the instance"
  value       = var.ssh_key_pair
}

output "security_group_ids" {
  description = "IDs on the AWS Security Groups associated with the instance"
  value = [aws_security_group.sg.id]
}

output "public_dns" {
  description = "Public DNS associated with the Elastic IP address"
  value       = aws_eip.eip.public_dns
}