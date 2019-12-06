input = "1, 1
1, 6
8, 3
3, 4
5, 5
8, 9"
#input = File.open("input6.txt").read

def pretty_print(grid)
  puts "+" + "-"*grid[0].length+ "+"
  for row in grid
    puts "|" + row.map{|cell| cell[0] ? (cell[0]+65).chr : " "}.join + "|"
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

grid = bounding_height.times.collect{bounding_width.times.collect{[nil, nil]}}
# puts "#{grid[0].length} x #{grid.length} grid"

coords.each_with_index do |point, idx|
  # Offset to (x_min,y_min) as (0,0)
  px = point[0] - (x_min+x0)
  py = point[1] - (y_min+y0)
  # puts "Point #{idx}: #{point.to_s} -> (#{px}, #{py})"
  grid.each_with_index do |row, y|
    row.each_with_index do |cell, x|
      dist = manhattan_distance([px, py], [x, y])
      if (cell[1] == nil) || dist < cell[1]
        cell[0] = idx
        cell[1] = dist
      elsif dist == cell[1]
        cell[0] = nil
        cell[1] = dist
      end
      # puts cell.to_s
    end
  end
end

pretty_print(grid)
cells = grid.flatten(1)
#puts cells.to_s
counts = []
coords.length.times {|i| counts << [i, cells.map{|cell| cell[0] == i ? 1 : 0}.reduce(:+)]}
puts counts.to_s
puts counts.map{|c| c[1]}.max

grid.each_with_index do |row, y|
  row.each_with_index do |cell, x|
    if x == 0 || x == x_end || y == 0 || y == y_end
      counts.delete_if{|count| count[0] == cell[0]}
    end
  end
end
puts counts.to_s
puts counts.map{|c| c[1]}.max
