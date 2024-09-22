resource "aws_placement_group" "main_placement" {
  name     = "hunky-dory-pg"
  strategy = "cluster"
}




resource "aws_launch_template" "dev_launch" {
  name = "foo"

  block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size = 20
    }
  }

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

  cpu_options {
    core_count       = 4
    threads_per_core = 2
  }

  credit_specification {
    cpu_credits = "standard"
  }

  disable_api_stop        = true
  disable_api_termination = true

  ebs_optimized = true

  iam_instance_profile {
    name = "valid-iam-profile-name" # Ensure this is a valid IAM profile
  }

  image_id = "ami-085f9c64a9b75eed5"

  instance_initiated_shutdown_behavior = "terminate"

  instance_market_options {
    market_type = "spot"
  }

  instance_type = "c5.large" # Ensure this instance type supports your CPU options

  key_name = "your-key-name"

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = true
  }

  placement {
    availability_zone = "us-west-2a"
  }

  vpc_security_group_ids = ["sg-12345678"] # Ensure this is a valid security group ID

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "test"
    }
  }

  user_data = filebase64("${path.module}/example.sh") # Ensure the file exists and is accessible
}
