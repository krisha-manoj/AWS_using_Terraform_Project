//This file contains the resources that shall be launched on AWS platform 

//Creating VPC 
resource "aws_vpc" "projectaws" {
  cidr_block = var.cidr

}

//Creating Subnet 1 
resource "aws_subnet" "sub1" {
  vpc_id            = aws_vpc.projectaws.id
  cidr_block        = var.sub1cidr
  availability_zone = "us-west-2a"
  //we need a public ip address assigned to resources 
  map_public_ip_on_launch = true

}

// Creating Subnet 2
resource "aws_subnet" "sub2" {
  vpc_id            = aws_vpc.projectaws.id
  cidr_block        = var.sub2cidr
  availability_zone = "us-west-2b"
  //we need a public ip address assigned to resources 
  map_public_ip_on_launch = true

}

// Creating Internet Gateway 
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.projectaws.id
}

//Creating route table
resource "aws_route_table" "route1" {

  vpc_id = aws_vpc.projectaws.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

// Creating Route Table association for Subnet 1 
resource "aws_route_table_association" "rtassociation1" {

  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.route1.id
}

// Creating Route Table association for Subnet 2 
resource "aws_route_table_association" "rtassociation2" {

  subnet_id      = aws_subnet.sub2.id
  route_table_id = aws_route_table.route1.id
}

// Creating a seperate security group 
resource "aws_security_group" "awssg" {

  name   = "awssg"
  vpc_id = aws_vpc.projectaws.id

}

// Attaching ingress rules on SG 
resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.awssg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
  description       = "Allow public HTTP traffic"
}

// Attaching egress to SG
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
  security_group_id = aws_security_group.awssg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # "-1" means all protocols
}


//Creating S3 bucket 

resource "aws_s3_bucket" "awskrisha12345" {
  bucket = "awskrishamanoj12345"

}

//Creating EC2 resource - 1

resource "aws_instance" "server1" {
  ami                    = "ami-02167eae61967e403"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.awssg.id]
  subnet_id              = aws_subnet.sub1.id
  user_data              = file("userdata.sh")

}

//Creating EC2 resource - 2

resource "aws_instance" "server2" {
  ami                    = "ami-02167eae61967e403"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.awssg.id]
  subnet_id              = aws_subnet.sub2.id
  user_data              = file("userdata2.sh")

}

// Creating Load Balancer 
resource "aws_lb" "myalb" {
  name               = "myalb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.awssg.id]
  // Assigning load balancer to subnets 
  subnets = [aws_subnet.sub1.id, aws_subnet.sub2.id]

}

// Load Balancer Target Group
resource "aws_lb_target_group" "tg" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.projectaws.id

  health_check {
    path = "/"
    port = "traffic-port"
  }

}

//Target Group Attachment 

resource "aws_lb_target_group_attachment" "tga" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.server1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "tga1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.server2.id
  port             = 80
}

// ALB listeners 

resource "aws_lb_listener" "list" {
  load_balancer_arn = aws_lb.myalb.arn
  port              = 80
  default_action {
    target_group_arn = aws_lb_target_group.tg.arn
    type             = "forward"
  }

}