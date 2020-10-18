resource "aws_db_instance" "employee" {
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  name                   = "employee"
  identifier             = "employee"
  parameter_group_name   = "default.mysql5.7"
  password               = "thr33littlew0rds"
  skip_final_snapshot    = true
  storage_type           = "gp2"
  username               = "Sleepycat"
  vpc_security_group_ids = [aws_security_group.employee.id]
}
