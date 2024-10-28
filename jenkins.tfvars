region                           = "ap-south-1"

# alb
internal                       = false
loadbalancer_type              = "application"
alb_subnets                    = ["subnet-08912e5dcff888919"]

#alb-sg
alb_ingress_cidr_from_port     = [80,443]
alb_ingress_cidr_to_port       = [80,443]
alb_ingress_cidr_protocol      = ["tcp","tcp"]
alb_ingress_cidr_block         = ["0.0.0.0/0"]
alb_create_ingress_cidr        = true

alb_ingress_sg_from_port       = [80]
alb_ingress_sg_to_port         = [80]
alb_ingress_sg_protocol        = ["tcp"]
alb_create_ingress_sg          = false

alb_egress_cidr_from_port      = [0]
alb_egress_cidr_to_port        = [0]
alb_egress_cidr_protocol       = ["-1"]
alb_egress_cidr_block          = ["0.0.0.0/0"]
alb_create_egress_cidr         = true

alb_egress_sg_from_port        = [0]
alb_egress_sg_to_port          = [0]
alb_egress_sg_protocol         = ["-1"]
alb_create_egress_sg           = false

# jenkins master sg
master_ingress_cidr_from_port         = [8080]
master_ingress_cidr_to_port           = [8080]
master_ingress_cidr_protocol          = ["tcp"]
master_ingress_cidr_block             = ["10.0.0.0/16"]
master_create_ingress_cidr            = true

master_ingress_sg_from_port           = [8080]
master_ingress_sg_to_port             = [8080]
master_ingress_sg_protocol            = ["tcp"]
master_create_ingress_sg              = false

master_egress_cidr_from_port          = [0]
master_egress_cidr_to_port            = [0]
master_egress_cidr_protocol           = ["-1"]
master_egress_cidr_block              = ["0.0.0.0/0"]
master_create_egress_cidr             = true

master_egress_sg_from_port            = [8080]
master_egress_sg_to_port              = [8080]
master_egress_sg_protocol             = ["tcp"]
master_create_egress_sg               = false

# jenkins slave sg
slave_ingress_cidr_from_port         = [22]
slave_ingress_cidr_to_port           = [22]
slave_ingress_cidr_protocol          = ["tcp"]
slave_ingress_cidr_block             = ["0.0.0.0/0"]
slave_create_ingress_cidr            = false

slave_ingress_sg_from_port           = [8080]
slave_ingress_sg_to_port             = [8080]
slave_ingress_sg_protocol            = ["tcp"]
slave_create_ingress_sg              = false

slave_egress_cidr_from_port          = [0]
slave_egress_cidr_to_port            = [0]
slave_egress_cidr_protocol           = ["-1"]
slave_egress_cidr_block              = ["0.0.0.0/0"]
slave_create_egress_cidr             = true

slave_egress_sg_from_port            = [8080]
slave_egress_sg_to_port              = [8080]
slave_egress_sg_protocol             = ["tcp"]
slave_create_egress_sg               = false

# target_group
target_group_port              = 8080
target_group_protocol          = "HTTP"
target_type                    = "instance"
load_balancing_algorithm       = "round_robin"

# health_check
health_check_path               = "/"
health_check_port               = 8080
health_check_protocol           = "HTTP"
health_check_interval           = 30
health_check_timeout            = 5
health_check_healthy_threshold  = 2
health_check_unhealthy_threshold= 2

# #alb_listener
listener_port                   = 80
listener_protocol               = "HTTP"
listener_type                   = "forward"

#launch_template
ami_id                           = "ami-0e94e462893adaa7b"
instance_type                    = "t4g.medium"
key_name                         = "jenkinsMaster_rsa"
vpc_id                           = "vpc-086c9ae4bf5b38287"
asg_subnets                      = ["subnet-09a1b9d82a187ddea"]
public_access                    = false
iam_role                         = "Jenkins_Master_Role"
subnet_ids                       = ["subnet-08912e5dcff888919"]

# user_data
user_data = <<-EOF
#!/bin/bash
sudo su
sudo apt install -y nfs-common
sudo mount -t nfs4 -o nfsvers=4.1 fs-0a5608d2608cdea65.efs.ap-south-1.amazonaws.com:/ /var/lib/jenkins
sudo echo 'fs-0a5608d2608cdea65.efs.ap-south-1.amazonaws.com:/ /var/lib/jenkins nfs4 defaults,nfsvers=4.1,_netdev 0 0' | sudo tee -a /etc/fstab
sudo chown -R jenkins:jenkins /var/lib/jenkin/
sudo systemctl restart jenkins
EOF

#autoscaling_group
max_size                         = 1
min_size                         = 1
desired_capacity                 = 1
propagate_at_launch              = true
instance_warmup_time             = 30
target_value                     = 50

#tags
owner                            = "devops"
environment                      = "shared"
application                      = "jenkins"





# slave_lt
slave_ami_id                           = "ami-08a90ce316dbff056"
slave_instance_type                    = "t4g.medium"
slave_key_name                         = "jenkinsMaster-rsa"
#slave_user_data
slave_user_data                        = <<-EOF
                                    #!/bin/bash
                                    ls
                                    
                                    
                                    

                                   EOF


