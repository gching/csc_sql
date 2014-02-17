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
  attr_accessor :conn, :relations
  def initialize
  	## A new Pgconn sets up a new connection to the database cs_assignment1
    @conn = PG::Connection.open(:dbname => 'cs_assignment1')
    @relations = ['country','club','player','stadium','match','ticket','competes','appearance']
    prepare_all
    prep_statements
  end

  ## Prepare all the relation's schemas
  def prepare_all(filename='initial')
    puts "Preparing from #{filename} file"
    ## Open the file to read each line and output it
    	File.open(filename, "r").each_line do |line|
        ## If an error occurs from dropping it, rescue and put it out to terminal
        begin
      	  output = line.chomp
          results = execute(output)
        rescue
          puts results
        end
    	end
  end

  ## Execute a SQL command
  def execute(sql_string)
  	return @conn.exec(sql_string)
  end


  ## Execute with a prepared statement
  def execute_prep(sql_string)


  end


  ## Close the current connection to the database
  def close_conn
  	@conn.close
  end



private

  ## Used to prep the statements for SQL execution
  def prep_statements(filename = 'relation_params')
    puts "Preparing statements from #{filename} file"
    File.open(filename, "r").each_line do |line|
      ## Get the line of relation and params
      output = line.chomp

      ## Convert to an array to get the first word
      arrayParams = output.split

      ## Get relation name and delete it from array
      relation_name = arrayParams[0]
      arrayParams.delete_at(0)

      ## Get the number of parameters
      numberParams = arrayParams.count

      ## Rejoin them back into strings if needed
      paramString = arrayParams.join(" ")

      ## Configure the number of params with the $ for the SQL
      paramsSQLspec = ""
      numberParams.times do |num|
        if num+1 == numberParams
          paramsSQLspec << "$#{numberParams}"
        else
          paramsSQLspec << "$#{num+1},"
        end
      end

      ## Finalize the SQL strings
      prep_state_name = "insert_#{relation_name}"
      act_sql_statement = "insert into #{relation_name} values (#{paramsSQLspec})"

      ## Prepare it
      @conn.prepare(prep_state_name, act_sql_statement)
    end
    
  end


end
## Connect to the PG database
## conn.prepare('statement1', 'insert into table1 (id, name, profile) values ($1, $2, $3)')
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

