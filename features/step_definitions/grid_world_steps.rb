require 'rspec'
require 'stringio'
require_relative("../../lib/gridworld.rb")

Given(/^The user has been prompted for co\-ordinates$/) do
  #http://engineering.nulogy.com/posts/mocking-standard-out-in-rspec/
  #Main.new
  $stdout = StringIO.new("Please enter the x and y co-ordinates for the Mars world grid")
  expect($stdout.string.chomp).to eq("Please enter the x and y co-ordinates for the Mars world grid")
end

When(/^The user enters the world (.*) and (.*) boundaries$/) do |x,y|
  #Stub gets.chomp "Require $STDINPUT"
  #http://stackoverflow.com/questions/17258630/how-do-i-write-an-rspec-test-for-a-ruby-method-that-contains-gets-chomp
  @x = Integer(x) rescue nil
  @y = Integer(y) rescue nil
  $stdin = StringIO.new("#{@x},#{@y}")
  expect($stdin.string).to eq("#{@x},#{@y}")
end

Then(/^The world should be created with those values$/) do
  @gridworld = GridWorld.new
end

But(/^The world should not be created if the value of any co-ordinate exceeds 50, is equal or below 0 or the entered input is not a number$/) do
  expect(lambda { @gridworld.create(@x,@y) }).to raise_error if @x.nil? or @x>50 or @x<=0
  expect(lambda { @gridworld.create(@x,@y) }).to raise_error if @y.nil? or @y>50 or @y<=0
end

And(/^The user should see the following (.*?)$/) do |output|
  expect(@gridworld.create(@x,@y)).to eq(output) unless @x.nil? or @x<=50 or @x>0
end
