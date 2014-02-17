## pg_ruby.rb ##
## February 17, 2014 ##
## Gavin Ching ##
## Used for testing of Postgresql and possibly outputting to CSV using Ruby ##


## Require the pg gem ##
require 'pg'


## Connect to the PG database
conn = PG::Connection.open(:dbname => 'cs_assignment1')
conn.prepare('create_country', "create table country (
    cid INTEGER PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    coach VARCHAR(20) NOT NULL)")

conn.exec_prepared('create_country')

conn.exec('DROP TABLE country CASCADE;')


## Close the connection with the database
conn.close
