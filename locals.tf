locals {
    comman_tags ={
        Project = var.project
        Environment = var.environment
        Terraform = "true"
    }

    vpc_final_tags = merge(
        local.comman_tags,
        
        {
        Name = "$(local.Project)-$(local.Environment)"
    },
    var.vpc_tags
    )
}