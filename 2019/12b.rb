# input = "<x=-1, y=0, z=2>
# <x=2, y=-10, z=-7>
# <x=4, y=-8, z=8>
# <x=3, y=5, z=-1>"
# input = "<x=-8, y=-10, z=0>
# <x=5, y=5, z=10>
# <x=2, y=-7, z=3>
# <x=9, y=-8, z=-3>"

# Puzzle Input
input = "<x=-4, y=-14, z=8>
<x=1, y=-8, z=10>
<x=-15, y=2, z=1>
<x=-17, y=-17, z=16>"

class Body
  attr_reader :position, :velocity

  def initialize(position, velocity=[0,0,0])
    @position = position
    @velocity = velocity
  end

  def state
    return [position.dup, velocity.dup]
  end

  def to_s
    return "pos=#{position.to_s}, vel=#{velocity.to_s}"#, PE=#{potential_energy}, KE=#{kinetic_energy}, TE=#{total_energy}"
  end

  def move_step
    position[0] += velocity[0]
    position[1] += velocity[1]
    position[2] += velocity[2]
  end

  def pull(other)
    3.times {|i| pull_axis(other, i)}
  end

  def pull_axis(other, axis_idx)
    if @position[axis_idx] > other.position[axis_idx]
      @velocity[axis_idx] -= 1
      other.velocity[axis_idx] += 1
    elsif @position[axis_idx] < other.position[axis_idx]
      @velocity[axis_idx] += 1
      other.velocity[axis_idx] -= 1
    end
  end

  def potential_energy
    # ruby version too old
    # return position.sum(&:abs)
    return position.reduce(0) {|sum, p| sum + p.abs}
  end

  def kinetic_energy
    # return velocity.sum(&:abs)
    return velocity.reduce(0) {|sum, v| sum + v.abs}
  end

  def total_energy
    return potential_energy * kinetic_energy
  end
end

def total_energy(bodies)
  return bodies.reduce(0) {|sum, body| sum + body.total_energy}
end

def gravity_step(bodies)
  for i in 0...bodies.length
    for j in i...bodies.length
      # puts "Pairwise #{i}, #{j}"
      if i != j
        bodies[i].pull(bodies[j])
      end
    end
  end
end

# Do bodies loop themselves within the broader loop?
# Not necessarily... anything from finding v=0 points?
# No... position repeats, maybe..?
# Ugh. Nope. Axis repeats?
# FINALLY
def check_repeat(bodies, start_state, periods, step_count)
  for axis in 0...3
    # puts "#{i}: #{bodies[i].state} #{start_state[i]}"
    # if periods[i] == nil && bodies[i].state == start_state[i]
    # if periods[i] == nil && bodies[i].velocity == [0,0,0]
    # if periods[i] == nil && bodies[i].position == start_state[i][0]
    if periods[axis] != nil
      next
    end
    if bodies.zip(start_state).map { |body, state| body.position[axis] == state[0][axis] && body.velocity[axis] == state[1][axis] }.all?
      periods[axis] = step_count
    end
  end
end

bodies = input.strip.split("\n").map do |scan|
  matches = scan.match(/<x=(-?\d+), y=(-?\d+), z=(-?\d+)>/)
  x = matches[1].to_i
  y = matches[2].to_i
  z = matches[3].to_i
  Body.new([x,y,z])
end

puts bodies
start_state = bodies.map{|body| body.state.dup}
# puts start_state.to_s

periods = []
loop.with_index do |_, i|
  # Number of steps counts from 1
  # if (i+1) % 100 == 0
  #   puts i+1
  # end
  gravity_step(bodies)
  bodies.each(&:move_step)
  # puts bodies
  check_repeat(bodies, start_state, periods, i+1)
  if (periods.length == 3 && periods.none?(&:nil?))
    break
  end
end

puts periods.to_s
puts periods.reduce(1, :lcm)
