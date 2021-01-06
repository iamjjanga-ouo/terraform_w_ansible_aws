resource "aws_lb" "ex_alb" {
  name               = "${var.vpc_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = aws_subnet.public.*.id

  tags = {
    Name = "${var.vpc_name}-alb"
    Environment = "development"
  }
}

resource "aws_lb_target_group" "ex_alb_target" {
  name     = "${var.vpc_name}-alb-target-group"
  port     = 80                                 # ALB-WEB doesn't need 443(HTTP) because of offloading
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_target_group_attachment" "ex_alb_target_attach" {
  count = length(var.availability_zones) # 2
  target_group_arn = aws_lb_target_group.ex_alb_target.arn
  target_id        = element(aws_instance.web.*.id, count.index)
  port             = 80
}

resource "aws_lb_listener" "ex_alb_listener_http" {
  load_balancer_arn = aws_lb.ex_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ex_alb_target.arn
//    type = "redirect"
//
//    redirect {
//      port        = "443"
//      protocol    = "HTTPS"
//      status_code = "HTTP_301"
//    }
  }
}

//resource "aws_lb_listener" "ex_alb_listener_https" {
//  load_balancer_arn = aws_lb.ex_alb.arn
//  port              = "443"
//  protocol          = "HTTPS"
//  ssl_policy        = "ELBSecurityPolicy-2016-08"
//  certificate_arn   = var.ssl_arn
//
//  default_action {
//    type             = "forward"
//    target_group_arn = aws_lb_target_group.ex_alb_target.arn
//  }
//}