resource "aws_instance" "new-instance" {
  count                       = local.inputs.create_instance ? length(local.inputs.ec2_instances) : 0
  ami                         = local.inputs.ec2_instances[count.index].ami_id
  instance_type               = local.inputs.ec2_instances[count.index].instance_type
  # associate_public_ip_address = true
  tags                        = {
    Name                      = local.inputs.ec2_instances[count.index].instance_name
    Environment               = local.inputs.ec2_instances[count.index].env
  }
  network_interface {
    device_index         = 0
    network_interface_id = "${aws_network_interface.newtwrk_interface.id}"
  }
}
 resource "aws_key_pair" "key-value" {
  key_name   = "key-pair-auth"
  public_key = file("C:\\Users\\SrijaPothamshetti\\Desktop\\Terraform-practices\\launch-ec2\\ec2-authentication.pub")
  
  # sensitive = true
}

resource "aws_network_interface" "newtwrk_interface" {
  # for_each    = var.subnet-ids
  subnet_id   = aws_subnet.subnet-1.id
  private_ip  = "172.31.1.6"
}

resource "aws_ebs_volume" "volume-1" {
  count              = local.inputs.create_volume ? length(local.inputs.ebs_volumes) : 0
  availability_zone  = local.inputs.ebs_volumes[count.index].az
  size               = local.inputs.ebs_volumes[count.index].size
  tags               = {
    name             = local.inputs.ebs_volumes[count.index].volume_name
}
}

resource "aws_volume_attachment" "attach-volume" {
  count       = local.inputs.create_instance ? length(local.inputs.ec2_instances) : 0
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.volume-1[count.index].id
  instance_id = aws_instance.new-instance[count.index].id
}

resource "aws_subnet" "subnet-1" {
  count      = local.inputs.create_subnet ? length(local.inputs.subnets) : 0
  vpc_id     = local.inputs.subnets[count.index].vpc_id
  cidr_block = local.inputs.subnets[count.index].cidr_value
  tags       = {
    name     = local.inputs.subnets[count.index].subnet_name
  }
}


