require 'ruby2d'

class Segment

  attr_accessor :x, :y, :current_direction

  def initialize(x = 400, y = 300, size = 10)
    @x = x
    @y = y
    @size = size
    @current_direction = ""
    Square.new(size: @size, x: @x, y: @y, color: "white")
  end

  def move!
    return if end_game
    case @current_direction
    when "right"
      @x += 10
    when "left"
      @x -= 10
    when "down"
      @y += 10
    when "up"
      @y -= 10
    end
    Square.new(size: @size, x: @x, y: @y, color: "white")
  end

  def rotate!(direction)
    @current_direction = direction
  end

  private

  def end_game
    if @x <= 0 || @x >= 800 - @size || @y <= 0 || @y >= 600 - @size
      Text.new("GAME OVER", x: 345, y:280)
    end
  end

end

class Consumable

  attr_accessor :x, :y, :type, :score_mod

  def initialize(type, size = 5)
    @x = rand(1..79) * 10
    @y = rand(1..59) * 10
    @size = size
    @type = type
    @score_mod = 10 if @type == "food"
    @score_mod = -50 if @type == "poison"
    Square.new(size: @size, x: @x, y: @y, color: "green") if @type == "poison"    
    Square.new(size: @size, x: @x, y: @y, color: "red") if @type == "food"
  end

  def display
    Square.new(size: @size, x: @x, y: @y, color: "green") if @type == "poison"    
    Square.new(size: @size, x: @x, y: @y, color: "red") if @type == "food"
  end

end

set width: 800, height: 600

segments = []
current_x_pos = 0
current_y_pos = 0

consumables = []

score = 0

3.times do |i|
  segments << Segment.new(400 - 10 * i)
end

on :key_down do |event|
  case event.key
  when "space"
    segments.each do |segment|
      segment.current_direction = "right" if segment.current_direction == ""
    end
  when "down"
    next if segments.first.current_direction == "up"
    current_x_pos = segments.first.x
    segments.first.rotate!("down")
  when "up"
    next if segments.first.current_direction == "down"
    current_x_pos = segments.first.x
    segments.first.rotate!("up")
  when "left"
    next if segments.first.current_direction == "right"
    current_y_pos = segments.first.y
    segments.first.rotate!("left")
  when "right"
    next if segments.first.current_direction == "left"
    current_y_pos = segments.first.y
    segments.first.rotate!("right")
  when "escape"
    close
  end
end 

update do
  if Window.frames % 3 == 0 
    clear
    segments.each do |segment|
      segment.rotate!("down") if segment.x == current_x_pos && segments.first.current_direction == "down"
      segment.rotate!("up") if segment.x == current_x_pos && segments.first.current_direction == "up"
      segment.rotate!("left") if segment.y == current_y_pos && segments.first.current_direction == "left"
      segment.rotate!("right") if segment.y == current_y_pos && segments.first.current_direction == "right"
      segment.move!
    end
    consumables << Consumable.new("food") unless consumables.any? { |consumable| consumable.type == "food" }
    consumables << Consumable.new("poison") if Window.frames % rand(1000..1100) == 0
    consumables.each do |consumable|
      consumable.display
      if consumable.x == segments.first.x && consumable.y == segments.first.y
        consumables.delete(consumable)
        score += consumable.score_mod
      end
    end
    Text.new("Score: #{score}")
  end
end

show