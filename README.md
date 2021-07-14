#Testing
For terraform :
 VPC with two public and private subnets
 Route tables for each subnet
 Security Group to allow port 80 and 443
 ELB and ALB
 Private route53 hosted zone and CNAME entry for both ALB and ELB 
 S3 role

For Ansible packer job2: 
Tasks :
  Install webserver (Nginx)
  Download code from git
  Configure webserver with security best practices
  Create a self-signed certificate
  Secure a demo site using self-signed certificate

Ansible playbook with packer job:
Tasks:
  Run Ansible playbook in a packer job and create AMI
  Automatically create ASG using AMI created in above step and attach it to ELB.
  Showcase capability of ALB, by created two different domain route policy
  Instance launched behind ELB/ALB should have role attached having access to s3 specific bucket, pull images from S3.

# packeransible
cd terraform/dev
terraform apply --var-file=dev.tfvar (terraform execution)
cd terraform/dev/packer
ansible-playbook main.yml -v (ansible execution)
