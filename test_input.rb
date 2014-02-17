## test_input.rb
## Gavin Ching
## February 17, 2014
## This file is used to test files for input


#################### Reading from File ###########################
puts "Insert file name:"
## Get the file name of the file being read.
filename = gets.chomp

## Open the file to read each line and output it
File.open(filename, "r").each_line do |line|
  output = line.chomp
  puts output
end

