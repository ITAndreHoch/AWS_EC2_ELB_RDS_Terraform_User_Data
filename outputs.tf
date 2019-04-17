############
# Outputs
############

output "rds_endpoint" {
  value = "${aws_db_instance.postgres.endpoint}"
}

output "elb_dns_name" {
  description = "The DNS name of the ELB"
  value       = "${aws_lb.LB-OneWeb.dns_name}"
}

output "IP_bastion" {
  value = ["${aws_instance.oneweb-bastion.public_ip}"]
}

output "IP_server1" {
  value = "${aws_instance.oneweb-server1.private_ip}"
}

output "IP_server2" {
  value = "${aws_instance.oneweb-server2.private_ip}"
}
