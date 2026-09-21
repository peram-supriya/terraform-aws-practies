variable "project" {
    type = string
  
}

variable "environment" {
    type = string
}

variable "cidr_block" {
    default = "10.0.0.0/16"
    type = string
  
}

variable "vpc_tags" {
    default = {}
    type = map
  
}

variable "gt_tags" {
    default = {}
    type = map
}

variable "public_sub_cidr" {
    default = ["10.0.1.0/24", "10.0.2.0/24"]
    type = list
  
}

variable "public_sub_tags" {
    default = {}
    type = map  
  
}

variable "private_sub_cidr" {
    default = ["10.0.11.0/24", "10.0.12.0/24"]
    type = list
  
}

variable "private_sub_tags" {
    default = {}
    type = map  
  
}

variable "database_sub_cidr" {
    default = ["10.0.21.0/24", "10.0.22.0/24"]
    type = list
  
}

variable "database_sub_tags" {
    default = {}
    type = map  
  
}