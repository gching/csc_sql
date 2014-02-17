################################################################
## pgconn.rb
## Gavin Ching
## February 17, 2014
## Used to interface with Postgresql DB using Ruby
################################################################


## Require the pg gem ##
require 'pg'

class Pgconn
  ## Set up attribute of the connection, which holds the connection with the PG db
  attr_accessor :conn
  def initialize
  	## A new Pgconn sets up a new connection to the database cs_assignment1
    @conn = PG::Connection.open(:dbname => 'cs_assignment1')
    prepare_all
  end

  ## Prepare all the relation's schemas
  def prepare_all
    

  end


  ## Close the current connection to the database
  def close_conn
  	@conn.close
  end





end
## Connect to the PG database
#conn = PG::Connection.open(:dbname => 'cs_assignment1')
=begin
conn.prepare('create_country', "create table country (
    cid INTEGER PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    coach VARCHAR(20) NOT NULL)")

conn.exec_prepared('create_country')

conn.exec('DROP TABLE country CASCADE;')


## Close the connection with the database
conn.close
=end

