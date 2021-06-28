resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits = 2048
}


resource "local_file" "cloud_pem" {
  filename = "example.pem"
  content = tls_private_key.example.private_key_pem
  file_permission = 600
}


resource "aws_key_pair" "deployer" {
  key_name   = "${terraform.workspace}.deployer-key"
  public_key = tls_private_key.example.public_key_openssh
}


resource "aws_instance" "webservers" {
   count = 3
   ami = var.instance_ami
   instance_type = var.instance_type
   security_groups = [aws_security_group.easyoay_webservers.id]
   subnet_id = aws_subnet.easypay_public.id

   key_name = aws_key_pair.deployer.key_name


   user_data = file("install_k8.sh")
}
