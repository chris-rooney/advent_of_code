input =
# "#########
# #b.A.@.a#
# #########"
# "########################
# #f.D.E.e.C.b.A.@.a.B.c.#
# ######################.#
# #d.....................#
# ########################"
"########################
#...............b.C.D.f#
#.######################
#.....@.a.B.c.d.A.e.F.g#
########################"

def print_map
  @grid.each do |line|
    line.each{|c| print c}
    print "\n"
  end
end

def find_in_grid(char)
  y = @grid.find_index {|line| line.find_index(char) != nil}
  return nil if y == nil
  x = @grid[y].find_index(char)
  return [x,y]
end

def get_cell(x, y)
  if x < 0 || y < 0 || y >= @grid.length
    return '#'
  else
    return @grid[y][x]
  end
end

def adjacent_cells(x, y)
  [[x-1, y], [x+1, y], [x, y-1], [x, y+1]]
end

def search_for_keys(keys, steps=0, cur_x=@x, cur_y=@y, last_x=nil, last_y=nil)
  cur_cell = get_cell(cur_x, cur_y)
    keys << [[cur_x, cur_y], cur_cell, steps] if cur_cell =~ /[a-z]/
  bfs = []
  adjacent_cells(cur_x, cur_y).each do |x, y|
    cell = get_cell(x, y)
    next if cell == nil || cell == '#' || cell == '@' || cell == '^'
    next if cell =~ /[A-Z]/
    bfs << [x, y] if [x, y] != [last_x, last_y] # We'd need something more if there were loops in the tunnels
  end
  # puts "[#{last_x}, #{last_y}] -> [#{cur_x}, #{cur_y}] -> #{bfs.to_s}"
  bfs.each{|x, y| search_for_keys(keys, steps + 1, x, y, cur_x, cur_y)}
  return keys
end

@grid = input.split("\n").map {|line|
  line.split('')
}
@x, @y = find_in_grid('@')

print_map
puts "#{@x}, #{@y}"

path = 0
loop do
  keys = []
  search_for_keys(keys)
  puts keys.to_s
  break if keys.empty?

  next_key = keys.first
  puts next_key.to_s

  @grid[@y][@x] = '.'
  @x, @y = next_key[0]
  @grid[@y][@x] = '^'

  door = find_in_grid(next_key[1].upcase)
  @grid[door[1]][door[0]] = '.' if door != nil
  path += next_key[2]

  print_map
  sleep(0.5)
end
puts path
# TODO DFS-Check for *fastest* path
