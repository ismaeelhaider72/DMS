data "aws_vpc" "vpc" {
  tags = {
    # this is a pre-existing vpc used for testing
    # please change to target a vpc in the expected account
    Name = "test"#"cloud-dev*"
  }
}

data "aws_subnets" "subnet" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }

  filter {
    name   = "subnet"
    values = ["test"]
  }
} 

module "dms" {
    source = "../.."

    name   = "test-DMS"

    # Master usernmae
    admin  = "username"  
    
    # Master username Password
    password = "username_password"  

    vpc_id   = data.aws_vpc.vpc.id  

    # primary_rds_endpoint = aws_db_instance.primary_mysql_rds-1.address
    # secondary_rds_endpoint = aws_db_instance.secondary_mysql_rds-1.addres

    replication_instance_class = "dms.t3.large"
    replication_instance_storage = 10
    replication_subnet_group_subnet_ids  = data.aws_subnets.subnet.ids
    engine_version   = "3.4.6"

    migration_type  = "full-load-and-cdc"
    
    region-primary  = "us-east-2"


    tags   = {
        Name = "test"
    }
}


