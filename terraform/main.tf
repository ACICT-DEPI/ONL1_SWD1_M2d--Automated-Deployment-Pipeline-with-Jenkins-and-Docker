module "vpc" {
  source   = "./vpc"
  vpc_cidr = "10.0.0.0/16"
  vpc_name = "pipeline-vpc"
}


# subnets
module "public_subnet1" {
  source      = "./subnet"
  vpc_id      = module.vpc.vpc_id
  cidr = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  subnet_name = "public-subnet1"
  map_on_launch = true
}


module "public_subnet2" {
  source      = "./subnet"
  vpc_id      = module.vpc.vpc_id
  cidr = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  subnet_name = "public-subnet2"
  map_on_launch = true
}
module "private_subnet1" {
  source      = "./subnet"
  vpc_id      = module.vpc.vpc_id
  cidr = "10.0.3.0/24"
  availability_zone = "us-east-1a"
  subnet_name = "private-subnet1"
  map_on_launch = false
}
module "private_subnet2" {
  source      = "./subnet"
  vpc_id      = module.vpc.vpc_id
  cidr = "10.0.4.0/24"
  availability_zone = "us-east-1b"
  subnet_name = "private-subnet2"
  map_on_launch = false
}



module "internet_gateway" {
  source = "./internet_gateway"
  vpc_id = module.vpc.vpc_id
  name   = "internet_gateway"
}

module "nat" {
  source    = "./nat_gateway"
  subnet_id = module.public_subnet1.subnet_id
  nat_name  = "load-balancer"
}

# public routing table
module "public_routing_table" {
  source             = "./route_table"
  vpc_id             = module.vpc.vpc_id
  gateway_id         = module.internet_gateway.internet_gateway_id
  routing_table_name = "public-routing-table"
}


# private routing table
module "private_routing_table" {
  source             = "./route_table"
  vpc_id             = module.vpc.vpc_id
  gateway_id         = module.nat.nat_gateway_id
  routing_table_name = "private-routing-table"
}

#  subnet  assossiation
module "public_assosiation_1" {
  source               = "./association"
  subnet_id            = module.public_subnet1.subnet_id
  route_table_id       = module.public_routing_table.routing_table_id
}

module "public_assosiation_2" {
  source               = "./association"
  subnet_id            = module.public_subnet_2.subnet_id
  route_table_id       = module.public_routing_table.routing_table_id
}


module "private_assosiation_1" {
  source               = "./association"
  subnet_id            = module.private_subnet1.subnet_id
  route_table_id       = module.private_routing_table.routing_table_id
}



module "private_assosiation_2" {
  source               = "./association"
  subnet_id            = module.private_subnet2.subnet_id
  route_table_id       = module.private_routing_table.routing_table_id
}


# security group
module "security_groups" {
  source = "./security_group"
  vpc_id = module.vpc.vpc_id
}


#key pair
module "key_pair" {
  source   = "./key-pair"
  key_name = "pipeline_key"
}

# instances
module "jenkins-agent" {
  source                    = "./public_instance"
  ami_id                    = "ami-0a0e5d9c7acc336f1" 
  instance_type             = "t2.micro"
  instance_name             = "jenkins-agent"
  public_subnet_id          = module.public_subnet1.subnet_id
  public_sg_id              = module.security_groups.public_sg_id
  depends_on = [ module.internet_gateway ]
  key_name                  = module.key_pair.key_name
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y python3-pip
              pip3 install ansible
              sudo apt install git-all
              sudo apt-get install openjdk-11-jdk -y
              curl -fsSL https://test.docker.com -o test-docker.sh
              sudo sh test-docker.sh
              curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash -
              sudo apt-get install -y nodejs
              EOF

}
module "jenkins_master" {
  source = "./instances"
  ami_id                    = "ami-0a0e5d9c7acc336f1" 
  instance_type             = "t2.micro"
  instance_name             = "jenkins-master"
  public_subnet_id          = module.public_subnet2.subnet_id
  public_sg_id              = module.security_groups.public_sg_id
  depends_on = [ module.internet_gateway ]
  key_name                  = module.key_pair.key_name
  user_data = <<-EOF
              #!/bin/bash
              sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
              https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

              echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
                  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
                  /etc/apt/sources.list.d/jenkins.list > /dev/null

              sudo apt-get update
              sudo apt install openjdk-17-jre-headless -y
              sudo apt-get install fontconfig openjdk-17-jre -y
              sudo apt-get install jenkins -y 
              EOF
}

module "web-app1" {
  source                    = "./private_instance"
  ami_id                    = "ami-0a0e5d9c7acc336f1" 
  instance_type             = "t2.micro"
  instance_name             = "web-app1"
  private_subnet_id          = module.private_subnet1.subnet_id
  private_sg_id              = module.security_groups.private_sg_id
  depends_on = [ module.nat ]
  key_name                  = module.key_pair.key_name
  user_data = ""

}

module "web-app2" {
  source                    = "./private_instance"
  ami_id                    = "ami-0a0e5d9c7acc336f1" 
  instance_type             = "t2.micro"
  instance_name             = "web-app2"
  private_subnet_id          = module.private_subnet2.subnet_id
  private_sg_id              = module.security_groups.private_sg_id
  depends_on = [ module.nat ]
  key_name                  = module.key_pair.key_name
  user_data = ""
}


# Load Balancer
module "load_balancer" {
  source                = "./load_balancer"
  vpc_id                = module.vpc.vpc_id
  public_subnets_id        = [module.public_subnet1.subnet_id , module.public_subnet2.subnet_id]

  private_id_1= module.web-app1.private_instance_id
  private_id_2 = module.web-app2.private_instance_id
  alb_sg_id             = module.security_groups.alb_sg_id
}



  