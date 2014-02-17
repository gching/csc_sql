################################################################
## pgconn_spec.rb
## Gavin Ching
## February 17, 2014
## Testing the class for connecting with PG database
################################################################

require_relative '../lib/pgconn.rb'

## For debugging
require 'pry'

describe 'An instance of', Pgconn do
  before do
    @pgconn = Pgconn.new
    @relations = ['country','club','player','stadium','match','ticket','competes','appearance']
  end 

  describe "a new" do
  	it "should have a connection with the PG database and not be finished" do
  	  expect(@pgconn.conn.finished?).to be_false
  	end
=begin
  	it "should have everything prepared" do
  	  @relations.each do |name|
  	  	expect(@pgconn.execute())

	  end
  	end
=end
  end

  describe "prepared schema" do

  	before do
  	  @pgconn.prepare_all
  	end
  	it "should reprepare everything with empty relations" do
  	  @relations.each do |name|
  	  	expect(@pgconn.execute("SELECT * FROM #{name}")).to be_a PG::Result
  	  end
  	end
  end


  describe "fake data" do
  	

  end


  
  describe "a closed" do
  	before do
  	  @pgconn.close_conn
  	end
  	it "should have the connection closed" do
  	  expect(@pgconn.conn.finished?).to be_true
  	end
  end
end