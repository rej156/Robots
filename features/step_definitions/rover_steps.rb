require 'stringio'
require 'rspec'
require_relative("../../lib/gridworld")
require_relative("../../lib/rover")

#Background setup start
Given(/^The world has been created with (\d+) and (\d+) limits$/) do |x, y|
  @x = Integer(x) rescue nil
  @y = Integer(y) rescue nil
  @issued_rovers = Array.new
  $lost_rovers = Array.new
  @gridworld = GridWorld.new
  $stdout = StringIO.new("The mars world grid has been created with (#{x},#{y}) dimensions")
  expect(@gridworld.create(@x,@y)).to eq($stdout.string)
end

When(/^I create a new rover at (\d+) and (\d+) with an orientation of "(.*?)"$/) do |x, y, orientation|
  @rover_spawn_x = Integer(x) rescue nil
  @rover_spawn_y = Integer(y) rescue nil
  @rover_spawn_orientation = orientation
  @rover = Rover.new
  $stdout = StringIO.new("You have spawned a rover on the mars grid at x:#{@rover_spawn_x},y:#{@rover_spawn_y} and with an orientation of #{@rover_spawn_orientation}")
  expect(@rover.spawn(@rover_spawn_x,@rover_spawn_y,@rover_spawn_orientation)).to eq($stdout.string.chomp)
  expect(@rover.x).to eq(@rover_spawn_x)
  expect(@rover.y).to eq(@rover_spawn_y)
  expect(@rover.orientation).to eq(orientation)
end

And(/^I issue "(.*?)" to that rover$/) do |commands|
  $stdout = StringIO.new("You have issued the following #{commands} commands to that rover.")
  expect(@rover.issue(commands)).to eq($stdout.string.chomp)
  @issued_rovers.push(@rover)
  $lost_rovers.push(@rover) if @rover.lost
end

Then(/^I should see the following "(.*?)" from that rover$/) do |output|
  expect(@rover.last_position).to eq(output)
  expect(@rover.x).to eq(1)
  expect(@rover.y).to eq(1)
  expect(@rover.orientation).to eq("E")
end
#Background setup end

And(/^I create another rover at (\d+) and (\d+) with an orientation of "(.*?)"$/) do |x,y,orientation|
  @rover_spawn_x = Integer(x) rescue nil
  @rover_spawn_y = Integer(y) rescue nil
  @rover_spawn_orientation = orientation
  @rover = Rover.new
  $stdout = StringIO.new("You have spawned a rover on the mars grid at x:#{@rover_spawn_x},y:#{@rover_spawn_y} and with an orientation of #{@rover_spawn_orientation}")
  expect(@rover.spawn(@rover_spawn_x,@rover_spawn_y,@rover_spawn_orientation)).to eq($stdout.string.chomp)
  expect(@rover.x).to eq(@rover_spawn_x)
  expect(@rover.y).to eq(@rover_spawn_y)
end

Then(/^I should see the following "(.*?)" from that robot considering it fell off the grid$/) do |output|
  expect(@rover.last_position).to eq(output)
  expect(@rover.x).to eq(3)
  expect(@rover.y).to eq(3)
  expect(@rover.orientation).to eq("N")
  expect(@rover.lost).to be_true
  expect($lost_rovers.length).to be(1)
end

And(/^I create a final rover at (\d+) and (\d+) with an orientation of "(.*?)"$/) do |x, y, orientation|
  @rover_spawn_x = Integer(x) rescue nil
  @rover_spawn_y = Integer(y) rescue nil
  @rover_spawn_orientation = orientation
  @rover = Rover.new
  $stdout = StringIO.new("You have spawned a rover on the mars grid at x:#{@rover_spawn_x},y:#{@rover_spawn_y} and with an orientation of #{@rover_spawn_orientation}")
  expect(@rover.spawn(@rover_spawn_x,@rover_spawn_y,@rover_spawn_orientation)).to eq($stdout.string.chomp)
  expect(@rover.x).to eq(@rover_spawn_x)
end

Then(/^It should ignore a forward command at the last robot's final position (\d+),(\d+) and "(.*?)" orientation$/) do |x, y, orientation|
  @rover.x = Integer(x) rescue nil
  @rover.y = Integer(y) rescue nil
  @rover.orientation = orientation
  @rover.move_forward
  expect(@rover.x).to eq(3)
  expect(@rover.y).to eq(3)
  expect(@rover.orientation).to eq(orientation)
  expect(@rover.lost).to be_false
end

And(/^I should see the following "(.*?)" from that last rover$/) do |output|
  @rover.x = 0
  @rover.y = 3
  @rover.orientation = "W"
  @rover.issue("LLFFFLFLFL")
  expect(@rover.last_position).to eq(output)
end

Then(/^I should see an ArgumentError once I issue an invalid (.*) command$/) do |commands|
  expect(lambda { @rover.verify_commands(commands) }).to raise_error(ArgumentError)
end

When(/^I create a new invalid rover at (.*) and (.*) with an orientation of "(.*)"$/) do |x, y, orientation|
  @rover_spawn_x = Integer(x) rescue nil
  @rover_spawn_y = Integer(y) rescue nil
  @rover_spawn_orientation = orientation
  @rover = Rover.new
end

Then(/^I should see an ArgumentError once I attempt to spawn it at that location$/) do
  expect(lambda { @rover.spawn(@rover_spawn_x,@rover_spawn_y,@rover_spawn_orientation) }).to raise_error(ArgumentError)
end
