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
- 