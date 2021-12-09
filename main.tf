provider "aws" {
  region = "sa-east-1"
}
# data "aws_ami" "ubuntu" {
#   most_recent = true
#   owners = ["099720109477"] # ou ["099720109477"] ID master com permissão para busca
#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-*"] # exemplo de como listar um nome de AMI - 'aws ec2 describe-images --region us-east-1 --image-ids ami-09e67e426f25ce0d7' https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-images.html
#   }
# }
# data http api {
#   url = "https://viacep.com.br/ws/03512050/json/unicode/"
#   request_headers = {
#     Accept = "application/json"
#   }
# }
data "http" "myip" {
  url = "http://ipv4.icanhazip.com" # outra opção "https://ifconfig.me"
}

data "aws_vpc" "selected" {
  filter {
    name = "tag:Name"
    values = ["vpc-turma3-ze"]
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "libera_ssh_ze_tf"
  description = "Allow SSH inbound traffic"
  vpc_id = "vpc-0b76bae68ca47a425"  #mudar
  ingress = [
    {
      description      = "SSH from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["${chomp( data.http.myip.body )}/32"]
      # cidr_blocks      = ["186.220.196.221/32"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids = null,
      security_groups = null,
      self            = null
    }
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"],
      prefix_list_ids  = null,
      security_groups  = null,
      self             = null,
      description      = "Libera dados da rede interna"
    }
  ]

  tags = {
    Name = "libera_ssh_ze_tf"
  }
}

variable "Name" {
  type        = string
  description = "Nome da instancia "

  validation {
    condition     = length(var.Name) > 1
    error_message = "O nome da instância nao e valido, tem que conter ao menos dois caracteres."
  }
}

resource "aws_key_pair" "chave_key" {
  key_name   = "id_rsa"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC+uZzLjELltYmQi5PlAIvtwjqvd49TtjK8LHnRv0XNUIlnDcuqqPubq1TEfABCEV/AlHsGbPryFApB2006PlSzOMoGKAP6tA2aYdI35hx/kQNl6DzReGQwwtYyxwJApVkBNbN6wTTGfLGs5/nmKMb2PHKfwvA6eXimsAITYt/ZZLr/cytSHyGdB7K2/DaucelmqN+iq1SbVLm//n2InEseTB/rY31qbJg8C6eT5z4a3o25DRDgo4/5yr3NGag9B6ogvfVUdW5RPxFI+IBpqnXMt5XE+XG4U+lpfMymMho05TNIoDmgdG7u3OCwpCVbU3ySYCX/LMbrE7usUuzAcATcGjYo5kz8fLIqdxiZu3iU0IRrwJ1SmzLo6QxDmX6XyijzEjR8Epb91FLi3ygjucp1FHsWZVXNqAj8lxTCBOPUHrCmIrtBFsIh65d6DzLIiwb1xUREicBnyG42X2Ul66IeZVG/4W/trCx+V7l3eh0Vol0Y74LuxtaA7HNfFRBmMus= ubuntu@montanhez-dev"
  }

resource "aws_instance" "web2" {
  subnet_id                   = var.subnet
  ami                         = var.image_id
  instance_type               = var.instance_type
  key_name                    = "id_rsa" # a chave que vc tem na maquina pessoal
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${aws_security_group.allow_ssh.id}"]
  root_block_device {
    encrypted   = true
    volume_size = var.tamanho
  }
  count = var.qtde
  tags = {
    Name = "${var.pre_name}-${var.Name}-${count.index}"
    #Tag2 = "Tag teste - ${var.maquinas[keys(var.maquinas)[count.index]]}"
  }
  depends_on = [
    aws_security_group.allow_ssh,
    aws_key_pair.chave_key
  ]
}

output "maquina_aws" {
  value = [
    for web in aws_instance.web2 :
    <<EOF
          Name: ${web.tags_all.Name}
          ssh -i id_rsa ubuntu@${web.public_ip}
          Public ip: ${web.public_ip}
        EOF
  ]
}

output ip {
  value       = "${chomp( data.http.myip.body )}/32"
  description = "output de ip"
}

# output api {
#   value       = jsondecode(data.http.api.body).bairro
# }

# output name {
#   value       = data.aws_ami.ubuntu.id
#   description = "output de ami"
# }
