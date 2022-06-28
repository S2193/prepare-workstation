# Install Docker engine

Resource 

#### install Docker engine

https://docs.docker.com/engine/install/ubuntu/



### Steps to execute this code

```
git clone https://github.com/thedevopsstore/prepare-workstation.git

cd  aws

# this code by default executes in us-east-1 region, and if you want to change, please update vars.tf file or pass a variable for region as below

terraform init

# terraform plan -var AWS_REGION=ap-south-1


terraform plan 

terraform apply

```






