class GridWorld

  def create(x,y)
    $x = Integer(x) rescue nil
    $y = Integer(y) rescue nil
    raise ArgumentError.new("Please enter valid world limits above 0,0 and between 50,50") if $x.nil?
    raise ArgumentError.new("Please enter valid world limits above 0,0 and between 50,50") if $x>50 or $x<=0
    raise ArgumentError.new("Please enter valid world limits above 0,0 and between 50,50") if $y.nil?
    raise ArgumentError.new("Please enter valid world limits above 0,0 and between 50,50") if $y>50 or $y<=0
    puts "The mars world grid has been created with (#{$x},#{$y}) dimensions"
    "The mars world grid has been created with (#{$x},#{$y}) dimensions\n"
  end
end