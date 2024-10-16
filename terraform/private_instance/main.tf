resource "aws_instance" "private_instance" {
  ami                   = var.ami_id
  instance_type         = var.instance_type
  subnet_id             = var.private_subnet_id
  security_groups       = [var.private_sg_id]
  key_name              = var.key_name

  user_data = var.user_data
  tags = {
    Name = var.instance_name
  }


}
resource "local_file" "instance_ip" {
  content  = aws_instance.private_instance.private_ip
  filename = "../${path.root}/inventory.ini"
}