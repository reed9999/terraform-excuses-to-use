#!/usr/bin/sh
# Quick start script to run our main benchmark sequence -- which is in evolution.

function do_body {
    ls -lrt 
}

# Informational
terraform validate
terraform plan 

# For the moment, Terraform still needs to prompt for database username and password; 
# I will ameliorate this soon. 
terraform apply -auto-approve
do_body
terraform destroy -auto-approve