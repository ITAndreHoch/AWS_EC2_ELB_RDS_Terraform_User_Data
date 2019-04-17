
###############
# DB Postgres
###############

resource "aws_db_subnet_group" "subnetdb" {
  name       = "subnetdb"
  subnet_ids = ["${aws_subnet.db1.id}", "${aws_subnet.db2.id}"]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "postgres" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "10.6"
  instance_class       = "db.t2.small"
  multi_az             = "false"
  username             = "postgres"
  password             = "postgres"
  db_subnet_group_name = "${aws_db_subnet_group.subnetdb.id}"
  vpc_security_group_ids = ["${aws_security_group.SG-DB.id}"]
  deletion_protection  = "false"
  skip_final_snapshot  = "true"
}

