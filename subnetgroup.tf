resource "aws_db_subnet_group" "default" {
  name       = var.subnet_groupname
  subnet_ids = var.subnet_ids

   tags = {
     Name = "DB subnet group"
    }
    }
    
    