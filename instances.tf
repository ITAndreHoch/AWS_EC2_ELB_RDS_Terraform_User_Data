############
# Bastion
############

# Bastion
resource "aws_instance" "web-bastion" {
  ami		              = "ami-xxx"
  instance_type               = "t2.micro"
  key_name                    = "web"
  subnet_id                   = "${aws_subnet.Public-Primary.id}"
  security_groups             = ["${aws_security_group.Bastion.id}"]
  associate_public_ip_address = "true"

  tags = {
    Name = "OneWeb-Bastion"
  }
}

###################
# Web-Server1
###################

resource "aws_instance" "web-server1" {
  ami                         = "ami-xxx"
  instance_type               = "t2.large"
  key_name                    = "web"
  subnet_id                   = "${aws_subnet.Private-Primary.id}"
  security_groups             = ["${aws_security_group.SG-OneWeb.id}"]

  user_data = <<-EOF
              #!/bin/bash
              timedatectl set-timezone Europe/Warsaw

              # Creating input sql script
              echo "DROP DATABASE IF EXISTS DBexampledb;" > /tmp/init.sql
              echo "" >> /tmp/init.sql
              [..]
              echo "CREATE ROLE USER_X LOGIN" >> /tmp/init.sql

              # Definition of RDS EndPoint - variable ($ep)
              ed="${aws_db_instance.postgres.endpoint}"
              ep=`echo $ed | awk -F":" '{print $1}'`

              # Run Postgres script
              export PGPASSWORD=postgres;/usr/bin/psql -U postgres -h "$ep" -d postgres < /tmp/init.sql ;
             
              # Replacing end point for RDS in conf files
              sed -i 's/RDSNAME/'"$ep"'/g' /data/webapps/data/databaseconfig.xml
              sed -i 's/RDSNAME/'"$ep"'/g' /data/webapps/conf/server.xml
 
              # Tomcat DB feed
              cd /data/webapps/active_server/web/data/
              java -jar /data/webapps/xxx.jar

              # Start Tomcat
              /etc/init.d/web start
              EOF

  depends_on = ["aws_db_instance.postgres"]

  tags = {
    Name = "OneWeb-Server1"
  }
  
}

##################
# Web-Server2
##################

resource "aws_instance" "web-server2" {
  ami                         = "ami-xxxx"
  instance_type               = "t2.large"
  key_name                    = "web"
  subnet_id                   = "${aws_subnet.Private-Secondary.id}"
  security_groups             = ["${aws_security_group.SG-OneWeb.id}"]

  user_data = <<-EOF
              #!/bin/bash
              timedatectl set-timezone Europe/Warsaw

              # Definition of RDS EndPoint - variable ($ep)
              ed="${aws_db_instance.postgres.endpoint}"
              ep=`echo $ed | awk -F":" '{print $1}'`
  
              # Replacing end point for RDS in conf files
              sed -i 's/RDSNAME/'"$ep"'/g' /data/webapps/data/databaseconfig.xml
              sed -i 's/RDSNAME/'"$ep"'/g' /data/webapps/conf/server.xml

              # Tomcat DB feed
              cd /data/webapps/active_server/web/data/
              java -jar /data/webapps/xxx.jar

              # Start Tomcat
              /etc/init.d/web start

              EOF

  depends_on = ["aws_instance.web-server1"]

  tags = {
    Name = "OneWeb-Server2"
  }
  
}
