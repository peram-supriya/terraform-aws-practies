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


