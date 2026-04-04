resource "aws_db_subnet_group" "mysql" {
  name       = "${local.name_prefix}-mysql-subnet-group"
  subnet_ids = [aws_subnet.private.id, aws_subnet.private_secondary.id]
  tags       = { Name = "${local.name_prefix}-mysql-subnet-group" }
}

resource "aws_db_instance" "mysql" {
  identifier     = "${local.name_prefix}-mysql"
  engine         = "mysql"
  engine_version = var.db_engine_version
  instance_class = var.db_instance_class

  allocated_storage = var.db_allocated_storage
  storage_type      = var.db_storage_type

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.mysql.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  multi_az                = var.db_multi_az
  backup_retention_period = var.db_backup_retention

  skip_final_snapshot = var.db_skip_final_snapshot

  tags = { Name = "${local.name_prefix}-mysql" }
}

resource "aws_db_instance" "mysql_replica_1" {
  identifier          = "${local.name_prefix}-mysql-replica-1"
  replicate_source_db = aws_db_instance.mysql.identifier
  instance_class      = var.db_instance_class
  availability_zone   = var.default_availability_zone

  vpc_security_group_ids = [aws_security_group.rds.id]
  skip_final_snapshot    = true
  tags                   = { Name = "${local.name_prefix}-mysql-replica-1" }
}

# replica 2 removed — free tier limits to 2 RDS instances total