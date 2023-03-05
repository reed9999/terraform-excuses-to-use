#!/usr/bin/sh
# Quick start script to run our main benchmark sequence -- which is in evolution.

export MYSQL_CLIENT="/c/Program Files/MySQL/MySQL Workbench 8.0/mysql" 
export OTHER_MYSQL_CLIENT="/c/Program Files/MySQL/MySQL Shell 8.0/bin/mysqlsh.exe" 

function do_body {
    echo
    echo "********************************************************************************"
    echo "This is your chance to do something interesting" 
    echo "You have 2 hours until I will shut down. (Or you can kill the script and risk" 
    echo "forgetting to \`terraform destroy\`)."
    echo "********************************************************************************"
    date 
    echo
    terraform show | grep endpoint
    # This isn't quite right -- need to `cut` it as well
    export AURORA_ENDPOINT=`terraform show | grep endpoint`
    # Try this when I get the chance: https://stackoverflow.com/questions/46536360/
    $MYSQL_CLIENT --help
    sleep 2h
    date 
    echo "Time's up! Now it's time to tear down."
}

# Informational
terraform validate
terraform plan 

# I will ameliorate this soon. 
terraform apply -auto-approve
do_body
terraform destroy -auto-approve