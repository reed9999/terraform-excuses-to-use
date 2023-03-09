#!/usr/bin/sh
# Called from main.sh. Does a redundant `terraform destroy`.
# For now, set env var TF_RDS_PASSWORD to match the terraform.tfvars (which should not be
# under version control!). We will integrate these better. 
export MYSQL_CLIENT=/c/Program\ Files/MySQL/MySQL\ Workbench\ 8.0/mysql
export OTHER_MYSQL_CLIENT="/c/Program Files/MySQL/MySQL Shell 8.0/bin/mysqlsh.exe" 

function do_body {
    duration=1h
    echo
    echo "********************************************************************************"
    echo "This is your chance to do something interesting" 
    echo "You have $duration until I will shut down. (Or you can kill the script and risk" 
    echo "forgetting to \`terraform destroy\`, or kill the \`sleep\` from another terminal)."
    echo "********************************************************************************"
    date 
    echo

    # only literal .cluster- because that's the format of the overall cluster EP, but not of individual nodes
    # exclude anything with reader beacuse we want the writer, which is just called `endpoint`
    working_endpoint=`terraform show|grep endpoint|grep "\.cluster-"|grep -v reader|head -1`
    working_endpoint=`cut -c 58- <<< "${working_endpoint}"`      # extract the value, but with double quotes    
    export AURORA_ENDPOINT=`cut -d\" -f2 <<< "${working_endpoint}"`    # 2nd field because opening quote creates an empty 1st field
    echo "****AURORA_ENDPOINT****"
    echo $AURORA_ENDPOINT
    echo ""
    # Try this when I get the chance: https://stackoverflow.com/questions/46536360/
    
    # *** CORE COMMANDS ***
    # Full command will be like: "$MYSQL_CLIENT" -h "$MYHOST" -P "$MYPORT" -u admin -p

    if [[ -z "$TF_RDS_PASSWORD" ]]; then
        echo "You must set TF_RDS_PASSWORD in the environment but I will still let you wait $duration"
        sleep $duration
        exit -1
    fi

    "$MYSQL_CLIENT" -h $AURORA_ENDPOINT -P 3306 -u admin --password=$TF_RDS_PASSWORD mydb < go.sql
    sleep $duration
    
    echo "Time's up! Now it's time to tear down."
    date 
}

# Don't need to do the apply here -- this script will be called from main.sh
do_body

terraform destroy -auto-approve
echo "terraform destroy completed at `date`"