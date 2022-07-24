# terraform-excuses-to-use
Learning Terraform by making myself automate things

## Subproject ideas

1. [`exampro`](./exampro) - Andrew Brown's marvelous 10-hour [AWS Certified Solutions Architect - Associate](https://www.youtube.com/watch?v=Ia-UEYYR44s) course. 
This covers the fundamental services of AWS in prep for the SA-A exam. 
Focus here will be on the numerous follow-alongs, with freedom to stray into other cool stuff
as I feel inclined.


    - [S3 follow along](https://www.youtube.com/watch?v=Ia-UEYYR44s&t=412s)
      - create buck and upload files

2. [`benchmark-emr-vs-db`](./benchmark-emr-vs-db) - Sort of a personal hobby horse. 
I intuit that Apache Spark (and consequently EMR) is probably overused in the wild,
because of multiple work projects where Spark was used as a fancy \[not R\]DBMS.
However I lack intuition for how much data is really big enough to be worth using Spark
like this -- especially since purpose built DBs or DWs such as Redshift are so much 
more performant than when Spark first showed up. 