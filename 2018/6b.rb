# input = "1, 1
# 1, 6
# 8, 3
# 3, 4
# 5, 5
# 8, 9"
# safe_dist = 32
input = File.open("input6.txt").read
safe_dist = 10000

def pretty_print(grid)
  puts "+" + "-"*grid[0].length+ "+"
  for row in grid
    puts "|" + row.map{|cell| cell ? "#" : " "}.join + "|"
  end
  puts "+" + "-"*grid[0].length+ "+"
end

def manhattan_distance(coord1, coord2)
  return (coord1[0] - coord2[0]).abs + (coord1[1] - coord2[1]).abs
end

coords = input.split("\n").map{|s| s.split(", ").map(&:to_i)}
# puts coords.to_s

x_min = coords.map{|c| c[0]}.reduce{|min, n| n > min ? min : n}
x_max = coords.map{|c| c[0]}.reduce{|max, n| n < max ? max : n}
y_min = coords.map{|c| c[1]}.reduce{|min, n| n > min ? min : n}
y_max = coords.map{|c| c[1]}.reduce{|max, n| n < max ? max : n}

# Grid inclusive
width = x_max - x_min + 1
height = y_max - y_min + 1
puts "Inner Grid: [#{x_min}, #{y_min}] to [#{x_max}, #{y_max}] (#{width} x #{height})"
# Double bounding box to detect infinite-area points
# So span from (-ceil(x/2), -ceil(y/2)) to (x+ceil(x/2), y+ceil(y/2))
x_bound_offset = (width/2r).ceil
y_bound_offset = (height/2r).ceil
x0 = x_min - x_bound_offset
y0 = y_min - y_bound_offset
x_end = x_max + x_bound_offset
y_end = y_max + y_bound_offset
bounding_width = x_end - x0 + 1
bounding_height = y_end - y0 + 1
puts "Bounding Grid: [#{x0}, #{y0}] to [#{x_end}, #{y_end}] (#{bounding_width} x #{bounding_height})"

grid = bounding_height.times.collect{ |y|
  bounding_width.times.collect{ |x|
    coords.map { |point|
      # Offset to (x0, y0)
      px = point[0] - (x_min+x0)
      py = point[1] - (y_min+y0)
      manhattan_distance([px, py], [x, y])
    }.reduce(:+) < safe_dist
  }
}

pretty_print(grid)
puts grid.flatten.count(true)
