require_relative("gridworld")

class Rover
  attr_accessor :x,:y,:orientation,:lost

  def spawn(x,y,orientation)
    @x = Integer(x) rescue nil
    @y = Integer(y) rescue nil
    verify_position(x,y,orientation)
    @orientation = orientation
    puts "You have spawned a rover on the mars grid at x:#{x},y:#{y} and with an orientation of #{orientation}"
    "You have spawned a rover on the mars grid at x:#{x},y:#{y} and with an orientation of #{orientation}"
  end

  def verify_position(x, y, orientation)
    raise ArgumentError.new('Please enter valid rover spawn co-ordinates and orientation e.g. "1 1 E"') if @x.nil? or @x<0 or @x > $x
    raise ArgumentError.new('Please enter valid rover spawn co-ordinates and orientation e.g. "1 1 E"') if @y.nil? or @y<0 or @y > $y
    raise ArgumentError.new('Please enter valid rover spawn co-ordinates and orientation e.g. "1 1 E"') unless orientation[/[NESW]/]
  end

  def issue(commands)
    verify_commands(commands)
    commands.each_char do |char|
      case char
        when "F" then move_forward
        when "L" then turn_left
        when "R" then turn_right
      end
    end
    puts "You have issued the following #{commands} commands to that rover."
    "You have issued the following #{commands} commands to that rover."
  end

  def last_position
    @lost ? "#{@x} #{y} #{orientation} LOST" : "#{@x} #{y} #{orientation}"
  end

  def verify_commands(commands)
    @invalid_command = true unless commands[/[FLR]/]
    raise ArgumentError.new('Please enter valid left,right forward commands to this rover e.g. "FLRFLRFLR"') if @invalid_command == true
    @invalid_command = false
  end

  def verify_lost
   @lost = true if @x > $x
   @lost = true if @x < 0
   @lost = true if @y > $y
   @lost = true if @y < 0
  end

  def at_previous_lost_coordinates
    @ignore_move_forward = false
    $lost_rovers.each do |lost_rover|
      @ignore_move_forward = true if @x == lost_rover.x and @y == lost_rover.y and @orientation == lost_rover.orientation
    end
    return @ignore_move_forward
  end

  def move_forward
    case @orientation
      when "N" then @y += 1 and verify_lost unless at_previous_lost_coordinates
      when "E" then @x += 1 and verify_lost unless at_previous_lost_coordinates
      when "S" then @y -= 1 and verify_lost unless at_previous_lost_coordinates
      when "W" then @x -= 1 and verify_lost unless at_previous_lost_coordinates
    end
  end

  def turn_left
    case @orientation
      when "N" then @orientation = "W"
      when "E" then @orientation = "N"
      when "S" then @orientation = "E"
      when "W" then @orientation = "S"
    end
  end

  def turn_right
    case @orientation
      when "N" then @orientation = "E"
      when "E" then @orientation = "S"
      when "S" then @orientation = "W"
      when "W" then @orientation = "N"
    end
  end

end