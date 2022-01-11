region = "us-east-2"

instance-associate-public-ip = true

security_group_rules = [  
    {
      from_port   = 3478
      to_port     = 3478
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
      description = "coturn"
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
    },
     {
      from_port   = 49160-59200
      to_port     = 49160-59200
      protocol    = "UDP"
      cidr_blocks = ["0.0.0.0/0"]
      description = "coturn"
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
    },
     {
      from_port   = 3306
      to_port     = 3306
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
      description = "MySQl"
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
    },
     {
      from_port   = 9090-9091
      to_port     = 9090-9091
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
      description = "openfire private_IP/32"
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
    },
     {
      from_port   = 9090-9091
      to_port     = 9090-9091
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
      description = "openfire AWS_PUBLIC_IP,/32"
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "SSH"
      cidr_blocks = ["0.0.0.0/0"]
      description = "openfire AWS_PUBLIC_IP,/32"
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
    }
 ]

 instance_type = "t3.medium"
