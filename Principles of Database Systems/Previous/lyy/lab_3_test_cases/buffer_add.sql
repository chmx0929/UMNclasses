drop table test_table;

CREATE TABLE test_table (id serial, PRIMARY KEY (id), value1 int not null, value2 int not null, value3 real, value4 real);

create index value1_index on test_table(value1);

set client_encoding = LATIN1;

COPY test_table(value1,value2,value3,value4) from '/home/lixx3524/4707/lab_3_test_cases/values10k.dat' DELIMITERS ';';
