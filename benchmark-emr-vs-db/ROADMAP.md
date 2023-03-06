# Benchmark EMR vs database subtask - Road Map

## Immediate punch list
- Get rid of secret in main-benchmark.tf! Obviously I only did this because it's a dev setup with very little risk, given that I tear these down within an hour or two.
- Automate the security group addition. Again, in a production setup we would require more
  careful thought and testing here.

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

## Bigger assessment: How far can I take this that's cost-effective? 

Hard to say so far. Stay tuned.

## Resources

- Terraform for MySQL interaction as well as RDS creation: https://stackoverflow.com/questions/71040112