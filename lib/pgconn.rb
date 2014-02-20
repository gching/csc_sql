################################################################
## pgconn.rb
## Gavin Ching
## February 17, 2014
## Used to interface with Postgresql DB using Ruby
################################################################


## Require the pg gem ##
require 'pg'
## Require the CSV read write file
##require 'csv_read_write.rb'



class Pgconn
  ## Set up attribute of the connection, which holds the connection with the PG db
  attr_accessor :conn, :relations
  def initialize
  	## A new Pgconn sets up a new connection to the database cs_assignment1
    @conn = PG::Connection.open(:dbname => 'cs_assignment1')
    @relations = Hash.new
    prepare_all
    prep_statements
    fake_data
  end

  ## Prepare all the relation's schemas
  def prepare_all
    puts "Preparing from initial, a2drop, a2tables files"
    ## Open the file to read each line and output it
    ["initial", "a2drop", "a2tables"].each do |filename|
      read_each_line_file(filename) do |line|
        results = execute(line)
      end
    end    
  end

  ## Execute a SQL command
  def execute(sql_string, dont_check = true)
  	results = @conn.exec(sql_string)
    ## Check if it is a create statement and append to file if it is
    unless dont_check
      check_create(sql_string)
    end
    return results
  end


  ## Execute with a prepared statement
  def execute_prep(sql_string)
  end

  ## Close the current connection to the database
  def close_conn
  	@conn.close
  end

  ## Insert fake data
  def fake_data
    ## Get it from each fake data csv files
    ## Get the keys for the proper file names
    @relations.each_key do |key|
      filename = "fake_#{key}.csv"
      ## Open up path for input of CSV data
      @conn.copy_data("COPY #{key} FROM STDOUT CSV") do
        ## Get the data from the CSV
        parseCSV(filename) do |row, lineNumber|
          ## If it is the first row then ignore it
          ## else insert it
          unless lineNumber == 1
            data = row.join(',') << "\n"
            @conn.put_copy_data data
          end
        end
      end
    end
  end

  ## Puts out all data currently in the database to the terminal
  def read_all_data

    @relations.each_key do |table|
      @conn.copy_data "COPY #{table} TO STDOUT CSV" do
        while row=@conn.get_copy_data
          p row
        end
      end
    end
  end

  ## Puts out the given table name tuples
  def read_table_tuples(tab_name)
    #@conn.copy_data "COPY #{tab_name} TO STDOUT CSV" do
     # while row=@conn.get_copy_data
      #  puts row
      #end
    #end
    return @conn.exec("TABLE #{tab_name}")
  end

  ## Create tables and views from a file
  def create_tab(filename)
    prepare_all(filename)
  end

  def drop_tab(filename)## Drop tables and views from a file
    prepare_all(filename)
  end

  def saveAnswer(sql)
    append_this("possibleAnswers", "Inserted at #{Time.now}")
    append_this("possibleAnswers", sql)
    append_this("possibleAnswers", "\n\n")
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

      ## Insert the values of the table into the hash
      @relations[relation_name] = paramString
    end
  end

  ## Used to check if the inputted statement is a Create and save it into the 2 required files
  def check_create(statement)
    ## Do if it has the Create statement
    if statement.upcase.include?("CREATE")
      puts "Storing in a2drop and a2tables"
      ## Append the Create to a2tables
      append_this("a2tables", statement)
      ## Create the statement for dropping it
      drop = statement.split[0..2]
      drop[0] = "DROP"
      drop = drop.join(" ")
      append_this("a2drop", drop)
    end
  end

  ## Append to a file
  def append_this(filename, appendMe)
    open(filename, 'a') do |f|
      f.puts appendMe
    end
  end


  ## Read from file
  def read_each_line_file(filename)
    ## Open the file to read each line and output it
      File.open(filename, "r").each_line do |line|
        ## If an error occurs from dropping it, rescue and put it out to terminal
        begin
          output = line.chomp
          yield output
        end
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

