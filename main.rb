################################################################################################################################################
## main.rb
## Gavin Ching
## This file is the parser of the interface of ruby with the database
################################################################################################################################################

Dir["lib/*.rb"].each {|file| require_relative file }	## Require mandatory library files from folder lib.

## For debugging
require 'pry'

## For the input 
def in_from_user
  print "$--"
  return gets.chomp
end

## To return results tuples
def tuple_print(results)
  results.each do |tuple|
    puts tuple
  end
end

## Instantiate the connection with the database
@pgconn = Pgconn.new
listTables = @pgconn.table_Names

exit_flag = false
sql_query = nil
result = nil

while (exit_flag == false) do
  puts "The possible commands, please input the integer:"
  puts "1) Input SQL query"
  puts "2) Prints the Table"
  puts "3) Reset all Relations"
  puts "4) Put all in a CSV file"
  puts "5) Get last result"
  puts "6) Save last query"
  puts "7) Create view"
  puts "8) Exit"
  puts "9 Reset all fake Data"
  puts "Current initial tables are:"
  puts "//"
  listTables.each do |name|
  print " #{name} "
  end
  puts "\n//"



  choice = in_from_user.to_i
  begin
	  case choice
	  when 1
	  	puts "Input your SQL query: End with semicolon"
	  	sql_query = in_from_user
	  	## implement into an array until a semicolon
	  	sql_query_array = [sql_query]
	  	while sql_query[sql_query.size-1] != ";"
	  		sql_query = in_from_user
	  		sql_query_array << sql_query
	  	end
	  	sql_query = sql_query_array.join(" ")
	  	puts "Query is:"
	  	puts "///"
	  	puts "/// #{sql_query}"
	  	puts "///"
	  	result = @pgconn.execute(sql_query, false)
	  	tuple_print(result)
	  	puts "Done outputting results."
	  when 2
	  	puts "Input the Relation name"
	  	relation_name = in_from_user
	  	result = @pgconn.read_table_tuples(relation_name)
	  	tuple_print(result)
	  when 3
	  	puts "Reseting everything? y/n"
	  	yesno = in_from_user
	  	if yesno == 'y'
	  	  @pgconn.prepare_all
	  	end
	  when 4
	  	puts "Putting all to a CSV file."
	  	puts "Still implementing"
	  when 5
	  	puts "The last result is"
	  	if result != nil
	  	  result.each do |tuple|
	        puts tuple
	  	  end
	  	else
	      puts "There is no last result"
	    end
	  when 6
	  	puts "The last SQL query is:"
	  	if sql_query != nil
	  	  puts sql_query

	  	  puts "Saving to file: possibleAnswers"
	  	  @pgconn.saveAnswer(sql_query)
	  	else
	  	  puts "Empty SQL query"
	  	end
	  when 7
	  	puts "Still implementing view creation and dropping"
	  when 8	
	  	puts "Exit? y/n"
	  	yesno = in_from_user
	  	if yesno == 'y'
	  	  puts "Closing connection and program."
	      @pgconn.close_conn
	      exit_flag = true
	    end
	  when 9
	  	puts "Reseting all fake data."
	  	@pgconn.resetAllData
	  end
  rescue Exception => error #PG::Error => error
  	puts "Error:"
  	puts error.message
  	puts error.backtrace.inspect
  end

  puts ""
  puts ""
  puts ""
end