-- go.sql - the heart of our SQL interaction with the new Aurora cluster

DROP TABLE IF EXISTS foo;

CREATE TABLE IF NOT EXISTS foo (
    -- I'm loading random data from my GDELT project so I don't recall what it even is.
    some_string varchar(20),
    one_number integer,
    another_number integer
    );


select 'Hello, ', 'world.', count(*) 
from foo;


GRANT AWS_LOAD_S3_ACCESS TO 'admin';

-- If your bucket isn't in us-west-2 then parametrize accordingly.
LOAD DATA FROM s3 's3-us-west-2://reed9999/sample.csv' 
INTO TABLE foo
COLUMNS TERMINATED BY ','
;

select 'updated count, ', 'dear world.', count(*) 
from foo;

select max(another_number) from foo;

