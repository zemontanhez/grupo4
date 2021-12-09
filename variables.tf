variable "image_id" {
  type = string
  default = "ami-0e66f5495b4efdd0f"  #alterar aqui
  description = "O id do Amazon Machine Image (AMI) para ser usado no servidor."
}

variable "subnet" {
  type = string
  default = "subnet-091d8530ca8d35a20"  #alterar aqui
  description = "O Subnet ID a ser usado."
}

variable "instance_type" {
  type = string
  default = "t2.nano"  #alterar aqui
  description = "Tipo da instancia"
}

variable "pre_name" {
  type = string
  default = "turma3-ec2-ze-tf-"    #alterar aqui
  description = "Prefixo default do nome a ser criado"
}

# variable "chave" {
#   type = string
#   default = "keypair-turma3-ze-dev"
#   description = "Par de chaves a ser usado"
# }

variable "tamanho" {
  type = number
  default = 8     #alterar aqui
  description = "Capacidade de storage da instancia"
}

variable "sec_group" {
  type = string
  default = "sg-0c493a481025a9028"    #alterar aqui
  description = "Securite Group a ser usado inicialmente"
}

variable "qtde" {
  type = number
  default = 1    #alterar aqui
  description = "Quantidade de instancias a ser criada"
}
