locals {
    Project = "roboshop"
    Environment = "dev"

    vpc_final_tags = {
        Name = "$(local.Project)-$(local.Environment)"
    }
}