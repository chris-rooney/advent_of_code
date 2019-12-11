input =
# ".#..#
# .....
# #####
# ....#
# ...##"
# "......#.#.
# #..#.#....
# ..#######.
# .#.#.###..
# .#..#.....
# ..#....#.#
# #..#....#.
# .##.#..###
# ##...#..#.
# .#....####"
# "#.#...#.#.
# .###....#.
# .#....#...
# ##.#.#.#.#
# ....#.#.#.
# .##..###.#
# ..#...##..
# ..##....##
# ......#...
# .####.###."
# ".#..#..###
# ####.###.#
# ....###.#.
# ..###.##.#
# ##.##.#.#.
# ....###..#
# ..#.#..#.#
# #..#.#.###
# .##...##.#
# .....#.#.."
# ".#..##.###...#######
# ##.############..##.
# .#.######.########.#
# .###.#######.####.#.
# #####.##.#.##.###.##
# ..#####..#.#########
# ####################
# #.####....###.#.#.##
# ##.#################
# #####.##.###..####..
# ..######..##.#######
# ####.##.####...##..#
# .#####..#.######.###
# ##...#.##########...
# #.##########.#######
# .####.#.###.###.#.##
# ....##.##.###..#####
# .#.#.###########.###
# #.#.#.#####.####.###
# ###.##.####.##.#..##"
File.open("input10.txt").read
laser_bet = 199

class Asteroid
  attr_reader :x, :y
  attr_accessor :visible

  def initialize(x, y)
    @x = x
    @y = y
    @visible = []
  end

  def to_s
    return "(#{x}, #{y}): #{visible.length}"
  end

  def has_los(field, target)
    if target == self
      return false
    end
    check_coords = trace_line(target)
    # puts "(#{@x}, #{@y}) -> (#{target.x}, #{target.y}): #{check_coords.to_s}"
    collision = field.find {|asteroid| check_coords.find{|coord| coord[0] == asteroid.x && coord[1] == asteroid.y}}
    return collision == nil
  end

  def trace_line(target)
    rightward = target.x > @x
    upward = target.y > @y
    if target.y == @y
      # Straight left/right
      range = rightward ? (@x+1)...target.x : (target.x+1)...@x
      # puts range
      return range.map {|x| [x, @y]}
    elsif target.x == @x
      # Straight up/down
      range = upward ? (@y+1)...target.y : (target.y+1)...@y
      # puts range
      return range.map {|y| [@x, y]}
    else
      # Line tracing
      # Use Rational to reduce fraction to smallest integer increments
      slope = Rational(target.y - @y, target.x - @x)
      tracer = [slope.denominator.abs * (rightward ? 1 : -1), slope.numerator.abs * (upward ? 1 : -1)]
      # Trace all integer points along the line connecting this asteroid to the target asteroid
      check_coords = []
      trace_x = @x + tracer[0]
      trace_y = @y + tracer[1]
      while (rightward ? (trace_x < target.x) : (trace_x > target.x))
        # puts "(#{trace_x}, #{trace_y})"
        check_coords << [trace_x, trace_y]
        trace_x += tracer[0]
        trace_y += tracer[1]
      end
      return check_coords
    end
  end
end

asteroids = []

map_rows = input.strip.split("\n")
map_rows.each_with_index do |row, j|
  row.each_char.with_index do |char, i|
    if char == "#"
      asteroids << Asteroid.new(i, j)
    end
  end
end

for asteroid in asteroids
  asteroid.visible = asteroids.select {|target| asteroid.has_los(asteroids, target)}
end

# puts asteroids
station = asteroids.max_by {|asteroid| asteroid.visible.length}
puts "Part One: #{station.to_s}"

# We already know that we can see at least 200 other asteroids,
# so step 2 is simpler for not having to account for revealed asteroids behind vaporized ones

def angle(station, asteroid)
  if asteroid.y == station.y
    theta = 0
  else
    theta = Math.atan2((asteroid.x-station.x), (asteroid.y-station.y))
  end
  # puts "(#{station.x}, #{station.y}) -> (#{asteroid.x}, #{asteroid.y}): #{theta}"
  return theta
end

# puts station.visible
# puts "---"
station.visible.sort! {|a1, a2| angle(station, a2) <=> angle(station, a1)}
# puts "---"
# station.visible.each {|asteroid| puts "(#{station.x}, #{station.y}) -> (#{asteroid.x}, #{asteroid.y}): #{angle(station, asteroid)}"}
puts station.visible[laser_bet]
