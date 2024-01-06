locals {
  ami  = var.ami != "" ? var.ami : join("", data.aws_ami.ubuntu.*.image_id)
}

data "aws_ami" "ubuntu" {
  most_recent = "true"

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "mykey" {
  key_name    = var.ssh_key_pair
  public_key  = "${file(var.PATH_TO_PUBLIC_KEY)}"
}

resource "aws_instance" "instance" {
  ami                         = data.aws_ami.ubuntu.id 
  instance_type               = "${var.instance-type}"
  associate_public_ip_address = "${var.instance-associate-public-ip}"
  subnet_id                   = "${aws_subnet.subnet.id}"
  key_name                    = "${aws_key_pair.mykey.key_name}"
  private_ip                  = var.private_ip
  monitoring                  = var.monitoring
  vpc_security_group_ids      = ["${aws_security_group.sg.id}"]

  provisioner "remote-exec" {
    inline = [
      "ssh-keygen -f aws_key",
      "mv aws_key aws_key.pub ./module/aws",
    ]
  }

  connection {
      type        = "ssh"
      host        = "${self.public_ip}"
      user        = "ubuntu"
      private_key = "${file("./module/aws/aws_key")}"
      timeout     = "4m"
   }

  tags = {
    Name = "${lower(var.prefix)}-ec2-instance"
  }
}

resource "aws_eip" "eip" {
  instance = aws_instance.instance.id
  domain = "vpc"
  
  tags = {
    Name = "${lower(var.prefix)}-eip"
  }
}

resource "aws_vpc" "vpc" {
  enable_dns_support = "true"
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = "true" #gives an internal host name
  instance_tenancy = "default"
  tags = {
    Name = "${lower(var.prefix)}-vpc"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id = "${aws_vpc.vpc.id}" 
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "${lower(var.prefix)}-subnet"
  }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name = "${lower(var.prefix)}-ig"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.ig.id}"
  }
}

resource "aws_route_table_association" "rta" {
  subnet_id      = "${aws_subnet.subnet.id}"
  route_table_id = "${aws_route_table.rt.id}"
}

resource "aws_security_group" "sg" {
  name = "${var.sg-tag-name}"
  vpc_id = "${aws_vpc.vpc.id}"

  ingress = [
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
      from_port   = 5222
      to_port     = 5223
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
      description = "XMPP"
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
    },
     {
      from_port   = 49160
      to_port     = 59200
      protocol    = "UDP"
      cidr_blocks = ["0.0.0.0/0"]
      description = "coturn"
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
    },
    {
      from_port   = 9090
      to_port     = 9091
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
      description = "openfire private_IP/32"
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
      description = "ssh /32"
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
    }
  ]

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${lower(var.prefix)}-sg"
  }
}

resource "aws_security_group_rule" "mysql" {
      type = "ingress"
      from_port   = 3306
      to_port     = 3306
      protocol    = "TCP"
      cidr_blocks = ["${aws_eip.eip.public_ip}/32"]
      description = "MySQl"
      security_group_id = "${aws_security_group.sg.id}"
}

resource "aws_security_group_rule" "openfire" {
      type = "ingress"
      from_port   = 9090
      to_port     = 9091
      protocol    = "TCP"
      security_group_id = "${aws_security_group.sg.id}"
      cidr_blocks = ["${aws_eip.eip.public_ip}/32"]
      description = "openfire public_ip/32"
}
