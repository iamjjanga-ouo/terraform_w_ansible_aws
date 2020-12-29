resource "aws_elb" "ext_elb" {
  name = "ext-elb"

  listener {
    instance_port = 8000
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  listener {
    instance_port = 8000
    instance_protocol = "http"
    lb_port = 443
    lb_protocol = "https"
    #ssl_certificate_id = ""
  }

  health_check {
    healthy_threshold = 2
    interval = 30
    target = "HTTP:8000/"
    timeout = 3
    unhealthy_threshold = 2
  }

  instances = aws_instance.web.*.id
}