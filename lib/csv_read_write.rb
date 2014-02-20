## csv_read_write.rb
## Gavin Ching - February 3rd, 2014
## Description: Reads the given CSV file
require 'CSV'


def parseCSV(filename)

	CSV.foreach(filename) do |row|
	 # puts "#{$.}" +" --- " + row[0] rescue nil
	   yield row, $.
	end

end


