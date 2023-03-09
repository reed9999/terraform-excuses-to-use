# Benchmark EMR vs database subtask - Road Map

## Immediate punch list
- ~~Read in a SQL script rather than multiple mysql calls~~.
- ~~load data with LOAD DATA FROM s3~~ (see below)
- Automate the security group addition. In a production setup we would require more
  careful thought and testing here.
- Automate attachment of the role plus linking of role via parameter group/parameter `aurora_load_from_s3_role` or `aws_default_s3_role`  
https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/AuroraMySQL.Integrating.Authorizing.IAM.AddRoleToDBCluster.html


## The roadmap
- ~~Follow basic tutorial on migrating to Aurora.~~ 
~~(Not that I need to *migrate* but it seems to be AWS' entry level "getting started" workflow.)~~
- Set up Aurora (via Terraform -- assume everything reasonable is automated).
- Populate Aurora with a small dataset (might require the shell script provider)
- Run some queries against it (same). 
- Assess time and cost.

- Set up EMR cluster.
- Populate with same dataset.
- Run same queries - adapt to Spark if need be (shouldn't need much adaptation).
- Assess

- Improve handling of secrets (see main-benchmark.tf variables).

## Things I've learned along the way

1. There was some issue with how I originally tried to create an Aurora cluster in TF. If memory serves, I was trying to use the TF setup for a non-Aurora RDS cluster and it contained something inappropriate for Aurora. Apparently I somehow set up a cluster with no instances! See comments in main-benchmark.tf for more.
2. "Publicly accessible" -- this is an attribute of an instance *within* the db cluster. It's not all that conspicuous upon creation nor to edit, but it can be edited by digging deeper into the settings. Or better yet, publicly_accessible = true in TF.
3. It seems like AWS just discontinued support for the 5.7 engine though I haven't confirmed. This required an upgrade in instance type.
4. I forgot that despite the "public accessible", I still need to add my own inbound traffic to the security group.   



### Disorganized history of what it took to get go.sql to work (sort of).
This fits under things I've learned but will be cleaned up.

Mostly pertains to the LOAD DATA FROM...

Aurora-specific -- see https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/AuroraMySQL.Integrating.LoadFromS3.html
First needs AIM role with appropriate policy -- see

https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/AuroraMySQL.Integrating.Authorizing.IAM.S3CreatePolicy.html
  (but I saved time on the previous by adding AmazonS3FullAccess on the new role per the following )
https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/AuroraMySQL.Integrating.Authorizing.IAM.AddRoleToDBCluster.html

The GRANT line worked, but LOAD DATA FROM failed with 
    ERROR 63985 (HY000) at line 19: S3 API returned error: Missing Credentials: Cannot instantiate S3 Client


Unhelpful thread: 
https://stackoverflow.com/questions/62612082/credential-is-missing-error-on-instantiating-s3-class-using-aws-sdk-js-v3

This however was helpful -- I'd neglected to add the role to the cluster (in addition to in the params set).
https://stackoverflow.com/a/42303005
Note it's a bit different now -- under the Connectivity & Security tab.

Then the next error I got is: 
  Internal error: Unable to initialize S3Stream instead.

Another answer on the same thread helped me figure that one out -- I needed the region of my 
s3 bucket on the URI in my SQL! So I changed the protocol to s3-us-west-2 and it works for a 
miniscule table (from sample.csv uploaded to s3).

This might have been helpful too: https://aws.amazon.com/premiumsupport/knowledge-center/amazon-aurora-upload-data-S3/

## Bigger assessment: How far can I take this that's cost-effective? 

Hard to say so far. Stay tuned.

## Resources

- Terraform for MySQL interaction as well as RDS creation: https://stackoverflow.com/questions/71040112