data "aws_vpc" "default" {
  default = var.vpc_id != "" ? false : true
  id      = var.vpc_id != "" ? var.vpc_id : ""
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name = "name"

    values = [
      "amzn2-ami-hvm-*-x86_64-gp2",
    ]
  }

  filter {
    name = "owner-alias"

    values = [
      "amazon",
    ]
  }
}

data "aws_ami" "ubuntu" {

  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "random_integer" "port" {
  min = 1025
  max = 65000
}
resource "aws_security_group" "allow_masq" {
  description = "Allow MASQ inbound traffic"
  vpc_id      = var.vpc_id != "" ? var.vpc_id : data.aws_vpc.default.id

  ingress {
    description      = "MASQ from All"
    from_port        = var.clandestine_port != null ? var.clandestine_port : random_integer.port.result
    to_port          = var.clandestine_port != null ? var.clandestine_port : random_integer.port.result
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_iam_role" "masq_ec2_role" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "masq_profile" {
  role = aws_iam_role.masq_ec2_role.name
}

resource "aws_iam_role_policy_attachment" "role-attach" {
  role       = aws_iam_role.masq_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_instance" "masq_node" {
  # count         = var.instance_count
  
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id != "" ? var.subnet_id : tolist(data.aws_subnet_ids.all.ids)[0]
  vpc_security_group_ids      = [aws_security_group.allow_masq.id]
  associate_public_ip_address = true
  key_name                    = var.key_name
  iam_instance_profile        = var.instance_role != "" ? var.instance_role : aws_iam_instance_profile.masq_profile.name
  tags = {
    "Name" = "${var.name}-${count.index + 1}"
  }

  count = var.instance_count




  user_data = templatefile("${path.module}/config.tpl", {
    chain            = var.chain
    bcsurl           = var.bcsurl
    clandestine_port = var.clandestine_port != null ? var.clandestine_port : random_integer.port.result
    dbpass           = var.dbpass
    dnsservers       = var.dnsservers
    earnwallet       = var.earnwallet
    downloadurl      = var.downloadurl
    gasprice         = var.gasprice
    conkey           = var.conkey
    mnemonic         = var.mnemonic
    centralLogging   = var.centralLogging
    centralNighbors     = var.centralNighbors
    customnNighbors     = var.customnNighbors
    agent_config     = base64encode(file("${path.module}/amazon-cloudwatch-agent.json"))
    index           = count.index
    mnemonicAddress           = element(var.mnemonic_list, count.index)
    earnwalletAddress           = element(var.earnwallet_list, count.index)
  })
}


