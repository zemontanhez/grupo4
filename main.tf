provider "aws" {
  region = "sa-east-1"
}
variable "image_id" {
  type        = string
  description = "O id do Amazon Machine Image (AMI) para ser usado no servidor."

  validation {
    condition     = length(var.image_id) == 21 && substr(var.image_id, 0, 4) == "ami-"
    error_message = "O valor do image_id não é válido, tem que começar com \"ami-\" e conter 21 caracters."
  }
}

variable "subnet" {
  type        = string
  description = "Subnet "

  validation {
    condition     = length(var.subnet) == 24 && substr(var.subnet, 0, 7) == "subnet-"
    error_message = "O valor do subnet não é válido, tem que começar com \"subnet-\" e conter 24 caracters."
  }
}

variable "instance_type" {
  type        = string
  description = "Tipo da instancia "

  validation {
    condition     = length(var.instance_type) > 6 && (substr(var.instance_type, 0, 3) == "t2." || substr(var.instance_type, 0, 3) == "t3.")
    error_message = "O tipo da instância não é válido, tem que começar com \"t2.\" ou \"t3.\"."
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

variable "chave" {
  type        = string
  description = "chave de segurança da instancia."

validation {
    condition     = length(var.chave) > 1 
    error_message = "A chave de segurança da instância nao e valido, tem que conter ao menos dois caracteres."
  }
}

variable "tamanho" {
  type        = string
  description = "Tamanho da instanci."

validation {
    condition     = (var.tamanho=="8" || var.tamanho=="16")
    error_message = "O tamanho da instância nao e valido, tem que 8 ou 16."
  }
}

variable "sec_group" {
  type        = string
  description = "Securite group da instancia."

validation {
    condition     = length(var.sec_group) == 20 && substr(var.sec_group, 0, 3) == "sg-"
    error_message = "O Securite group da instância nao e valido, tem que começar com sg- e conter 20 caracters."
  }
}


resource "aws_instance" "web2" {
 
  subnet_id = var.subnet
  ami = var.image_id
  instance_type = var.instance_type
  key_name =  var.chave # a chave que vc tem na maquina pessoal
  associate_public_ip_address = true
  vpc_security_group_ids = [var.sec_group]
  root_block_device {
    encrypted = true
    volume_size = var.tamanho
  }

  tags = {
    Name = "turma3-ec2-ze-tf-${var.Name}"
    #Tag2 = "Tag teste - ${var.maquinas[keys(var.maquinas)[count.index]]}"
  }
}

output "maquina_aws" {
    value = [
        aws_instance.web2.public_ip,
        aws_instance.web2.public_dns
    ]
}

#subnet-091d8530ca8d35a20 (subnet-ze-1a)
#ami-0e66f5495b4efdd0f
#sg-0c493a481025a9028 (secgroup-turma3-ze)
#keypair-turma3-ze-dev
