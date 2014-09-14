require_relative("gridworld")
require_relative("rover")

class Main
  puts('Please enter the x and y boundary value of the Mars grid world e.g. "5 3"')
  user_input = gets.chomp
  limits = user_input.to_s.split(" ")
  @x_limit = Integer(limits.first) rescue nil
  @y_limit = Integer(limits.last) rescue nil
  while @x_limit.nil? or @x_limit <= 0 or @x_limit > 50 or @y_limit.nil? or @y_limit <= 0 or @y_limit > 50
    puts('Please enter valid x and y boundary values of the Mars grid world above "0 0" and between "50 50"')
    user_input = gets.chomp
    limits = user_input.to_s.split(" ")
    @x_limit = Integer(limits.first) rescue nil
    @y_limit = Integer(limits.last) rescue nil
  end

  @gridworld = GridWorld.new
  @gridworld.create(@x_limit,@y_limit)

  puts('How many rovers do you want to issue commands for?')
  no_of_rovers = Integer(gets.chomp) rescue nil
  while no_of_rovers.nil? or no_of_rovers <= 0
    puts 'Please enter a valid number of robots above 0'
    no_of_rovers = Integer(gets.chomp) rescue nil
  end
  issued_rovers = Array.new
  $lost_rovers = Array.new

  no_of_rovers.times {
    puts('Please enter the x,y co-ordinates and orientation of a spawned rover to crawl the Mars grid world e.g. "1 1 E"')
    user_input = gets.chomp
    rover_spawn_properties = user_input.to_s.split(" ")
    @rover_spawn_x = Integer(rover_spawn_properties.first) rescue nil
    @rover_spawn_y = Integer(rover_spawn_properties[1]) rescue nil
    @rover_spawn_orientation = rover_spawn_properties[2]

    while @rover_spawn_x.nil? or @rover_spawn_x < 0 or @rover_spawn_x > $x or @rover_spawn_y.nil? or @rover_spawn_y < 0 or @rover_spawn_y > $y or !@rover_spawn_orientation[/[NESW]/]
      puts('Please enter the x,y co-ordinates and orientation of a spawned rover to crawl the Mars grid world e.g. "1 1 E"')
      user_input = gets.chomp
      rover_spawn_properties = user_input.to_s.split(" ")
      @rover_spawn_x = Integer(rover_spawn_properties.first) rescue nil
      @rover_spawn_y = Integer(rover_spawn_properties[1]) rescue nil
      @rover_spawn_orientation = rover_spawn_properties[2]
    end

    @rover = Rover.new
    @rover.spawn(@rover_spawn_x,@rover_spawn_y,@rover_spawn_orientation)

    puts('Please issue forward, left, right commands to this rover e.g. FLRFLRFLRFLR')
    @commands = gets.chomp
    while !@commands[/[FLR]/]
      puts('Please issue correct commands e.g. FLRFLRFLR')
      @commands = gets.chomp
    end

    @rover.issue(@commands)

    issued_rovers.push(@rover)
    $lost_rovers.push(@rover) if @rover.lost
  }

  puts 'The output of issued rovers is as following:'
  issued_rovers.each do |rover|
    puts rover.last_position
  end

end