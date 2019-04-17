################
# Load Balancer
################

resource "aws_lb" "LB-OneWeb" {
  name               = "LB-OneWeb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.SG-OneWeb.id}"]
  subnets            = ["${aws_subnet.Public-Primary.id}","${aws_subnet.Public-Secondary.id}"]
  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "lb-tg" {
  name     = "lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.VPC-OneWeb.id}"
}


resource "aws_lb_listener" "lb-listener" {
  load_balancer_arn = "${aws_lb.LB-OneWeb.arn}"
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.lb-tg.arn}"
  }
}

resource "aws_lb_target_group_attachment" "lb-attachment-Server1" {
  target_group_arn = "${aws_lb_target_group.lb-tg.arn}"
  target_id        = "${aws_instance.oneweb-server1.id}"
  port             = 8080
}

resource "aws_lb_target_group_attachment" "lb-attachment-Server2" {
  target_group_arn = "${aws_lb_target_group.lb-tg.arn}"
  target_id        = "${aws_instance.oneweb-server2.id}"
  port             = 8080
}
