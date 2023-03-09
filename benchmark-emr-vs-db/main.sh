#!/usr/bin/sh
# Quick start script to run our main benchmark sequence -- which is in evolution.

export MYSQL_CLIENT=/c/Program\ Files/MySQL/MySQL\ Workbench\ 8.0/mysql
export OTHER_MYSQL_CLIENT="/c/Program Files/MySQL/MySQL Shell 8.0/bin/mysqlsh.exe" 



# Informational
terraform validate
terraform plan 

export TEMP_TERRAFORM_OUTPUT=./temp_terraform_output.txt
# We don't really need to output this -- terraform show seems adequate.
terraform apply -auto-approve > $TEMP_TERRAFORM_OUTPUT

./do_body.sh

terraform destroy -auto-approve
echo "terraform destroy completed (from main - possibly redundant) at `date`"
rm $TEMP_TERRAFORM_OUTPUT


