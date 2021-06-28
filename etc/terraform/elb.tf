resource "aws_elb" "easypay_weblb" {
  name = "easypay-weblb"

  subnets = [aws_subnet.easypay_public.id]

  security_groups = [aws_security_group.easyoay_webservers.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/index.html"
    interval            = 30
  }

  instances                   = [aws_instance.webservers[0].id, aws_instance.webservers[1].id, aws_instance.webservers[2].id]
  cross_zone_load_balancing   = true
  idle_timeout                = 100
  connection_draining         = true
  connection_draining_timeout = 300

  tags = {
    Name = "Easypay - Web Load Balancer"
  }
}


resource "aws_elb" "easypay_kubelb" {
  name = "easypay-kubelb"

  subnets = [aws_subnet.easypay_public.id]

  security_groups = [aws_security_group.easyoay_webservers.id]

  listener {
    instance_port     = 6443
    instance_protocol = "tcp"
    lb_port           = 6443
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTPS:6443/livez"
    interval            = 30
  }

  instances                   = [aws_instance.webservers[0].id, aws_instance.webservers[1].id, aws_instance.webservers[2].id]
  cross_zone_load_balancing   = true
  idle_timeout                = 100
  connection_draining         = true
  connection_draining_timeout = 300

  tags = {
    Name = "Easypay - Kube Load Balancer"
  }
}

output "elb-dns-name" {
  value = aws_elb.easypay_weblb.dns_name
}
