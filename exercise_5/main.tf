provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

terraform {
  backend "s3" {
  bucket = "gabs-remote-tf-state-bucket"
  key = "terraform-lab6.tfstate"
  region = "us-east-2"
  }
}

resource "aws_ecs_cluster" "ecs-cluster-1" {
    name = var.ecs-cluster-1

}

  resource "aws_autoscaling_group" "ecs-autoscaling-group-1" {
    name                        = "ecs-asg-${var.ecs-cluster-1}"
    max_size                    = "4"
    min_size                    = "1"
    desired_capacity            = var.capacity
    vpc_zone_identifier         = ["subnet-921d17fa","subnet-51a8e82b"]
    launch_configuration        = aws_launch_configuration.ecs-launch-configuration-1.name
    health_check_type           = "ELB"
    tag {
      key                 = "Name"
      value               = "Gabs - ECS - EC2 Nodes - Lab 6"
      propagate_at_launch = true
    }   
  }
  resource "aws_launch_configuration" "ecs-launch-configuration-1" {
    name                        = "ecs-lb-${var.ecs-cluster-1}"
    image_id                    = "ami-0a0ad6b70e61be944"
    instance_type               = "t2.medium"
    iam_instance_profile        = "ecsInstanceRole"
    root_block_device {
      volume_type = "standard"
      volume_size = 20
      delete_on_termination = true
    }
    lifecycle {
      create_before_destroy = true
    }
    security_groups             = ["sg-0a8ef27e8b284caa0"]
    associate_public_ip_address = "true"
    key_name                    = "cs_gabs_keypair"
    user_data                   = <<EOF
                                  #!/bin/bash
                                  echo ECS_CLUSTER=${var.ecs-cluster-1} >> /etc/ecs/ecs.config
                                  EOF
}
