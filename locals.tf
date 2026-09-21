locals {
    Project = var.project
    Environment = var.environment

    vpc_final_tags = {
        Name = "$(local.Project)-$(local.Environment)"
    }
}