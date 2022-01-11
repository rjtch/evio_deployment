variable "region" {
    default = "us-east-1"
}

variable "prefix" {
  default = "evio"
}

variable "stage" {
  default = "test"
}

variable "sg-tag-name" {
  description = "The Name to apply to the security group"
  type        =   string
}

variable "PATH_TO_PUBLIC_KEY"  {
  default = "/home/rjtch/Desktop/workspace/evio_deployment/module/aws/aws_key.pub"
}

variable "ssh_key_pair" {
  type        = string
  description = "SSH key pair to be provisioned on the instance"
  default     = "aws_key"
}

variable "instance_type" {
  type        = string
  description = "The type of the instance"
  default     = "t3.medium"
}

variable "instance-associate-public-ip" {
  type        = bool
  description = "Associate a public IP address with the instance"
  default     = true
}

variable "security_group_enabled" {
  type        = bool
  description = "Whether to create default Security Group for EC2."
  default     = true
}

variable "security_group_description" {
  type        = string
  default     = "EC2 Security Group"
  description = "The Security Group description."
}

variable "metric_name" {
  type        = string
  description = "The name for the alarm's associated metric. Allowed values can be found in https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/ec2-metricscollected.html"
  default     = "StatusCheckFailed_Instance"
}

variable "monitoring" {
  type        = bool
  description = "Launched EC2 instance will have detailed monitoring enabled"
  default     = true
}

variable "private_ip" {
  type        = string
  description = "Private IP address to associate with the instance in the VPC"
  default     = ""
}

variable "security_groups" {
  description = "A list of Security Group IDs to associate with EC2 instance."
  type        = list(string)
  default     = []
}

variable "security_group_rules" {
  type = list(any)
  default = [
    {
      type        = "ingress"
      from_port   = 0
      to_port     = 3478
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
      description = "coturn"
    }
  ]
  description = <<-EOT
    A list of maps of Security Group rules. 
    The values of map is fully complated with `aws_security_group_rule` resource. 
    To get more info see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule .
  EOT
}

variable "security_group_use_name_prefix" {
  type        = bool
  default     = false
  description = "Whether to create a default Security Group with unique name beginning with the normalized prefix."
}

variable "instance-type" {
  description = "The instance type to be used"
  default     = "t3.medium"
}

variable "ami" {
  description = "The AMI (Amazon Machine Image) that identifies the instance"
  default     = ""
}
