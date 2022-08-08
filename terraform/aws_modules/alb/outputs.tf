
output "aws_lb_target_group_green_name" {
  value = aws_lb_target_group.green.name
}

output "aws_lb_target_group_blue_name" {
  value = aws_lb_target_group.blue.name
}

output "aws_lb_listener_green_arn" {
  value = aws_lb_listener.https_prod.arn
}

output "aws_lb_listener_blue_arn" {
  value = aws_lb_listener.https_test.arn
}

output "alb_sg_id" {
  value = aws_security_group.lb_sg.id
}
output "alb_dns" {
  value = aws_lb.this.dns_name
}
output "aws_lb_target_group_green_arn" {
  value = aws_lb_target_group.green.arn

}