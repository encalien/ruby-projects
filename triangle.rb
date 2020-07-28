require 'pry'

class TriangleDrawer
	attr_reader :n

  def initialize(n) #n = višina trikotnika =  št. vrstic
  	@n = n
  end

  def print_right
  	@n.times do |i|
			print "|"
 			print (i == @n - 1 ? "_" : " ") * i.to_i
 			puts "\\"
		end
  end

  def print_isosceles
  	@n.times do |i|
			print " " * ((n-i).to_i / 2) + "/"
 			print (i == @n - 1 ? "_" : " ") * i.to_i
 			puts "\\"
		end
  end

  def print_equilateral
  	@n.times do |i|
			print " " * (n-i).to_i + "/"
 			print (i == @n - 1 ? "__" : "  ") * i.to_i
 			puts "\\"
		end
  end
end

TriangleDrawer.new(ARGV[0].to_i).print_right
puts
TriangleDrawer.new(ARGV[1].to_i).print_equilateral
