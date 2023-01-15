# Benchmark EMR vs database subtask - Road Map

- Follow basic tutorial on migrating to Aurora. 
(Not that I need to *migrate* but it seems to be AWS' entry level "getting started" workflow.)
- Set up Aurora (via Terraform -- assume everything reasonable is automated).
- Populate Aurora with a small dataset (might require the shell script provider)
- Run some queries against it (same). 
- Assess time and cost.

- Set up EMS cluster.
- Populate with same dataset.
- Run same queries - adapt to Spark if need be (shouldn't need much adaptation).
- Assess

- Improve handling of secrets (see main-benchmark.tf variables).

## Things I've learned along the way

1. There was some issue with how I originally tried to create an Aurora cluster in TF. If memory serves, I was trying to use the TF setup for a non-Aurora RDS cluster and it contained something inappropriate for Aurora. Apparently I somehow set up a cluster with no instances! See comments in main-benchmark.tf for more.
2. "Publicly accessible" -- this is an attribute of an instance *within* the db cluster. It's not all that conspicuous upon creation nor to edit, but it can be edited by digging deeper into the settings. Or better yet, publicly_accessible = true in TF.    

## Bigger assessment: How far can I take this that's cost-effective? 