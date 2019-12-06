# input = "COM)B
# B)C
# C)D
# D)E
# E)F
# B)G
# G)H
# D)I
# E)J
# J)K
# K)L
# K)YOU
# I)SAN"
input = File.open("input6.txt").read

orbits = input.split("\n")
# .shuffle
# puts orbits.to_s

class Body
  attr_reader :name
  attr_accessor :satellites
  attr_accessor :orbitee

  def initialize(name, orbitee)
    @name = name
    @orbitee = orbitee
    @satellites = []
  end

  def to_s
    "#{name}: #{satellites}"
  end

  def orbits(n=0)
    if satellites.empty?
      return n
    else
      return n + satellites.map{|sat| sat.orbits(n+1)}.reduce(:+)
    end
  end

  def pretty_print(tabs=0)
    puts "#{"\t"*tabs}#{name} (#{orbitee ? orbitee.name : 'NA'}): #{orbits} ["
    satellites.each{|sat| sat.pretty_print(tabs+1)}
    puts "#{"\t"*tabs}]"
  end

  def has_satellite(sat_name)
    if name == sat_name
      return true
    else
      return satellites.map{|sat| sat.has_satellite(sat_name)}.reduce(false) {|r,v| r || v}
    end
  end

  def trace_route(target, path=[])
    path << name
    # Go "up" until we're at a body that has the target orbiting it
    # Then go "down" until we're directly orbiting the same body as the target
    if !has_satellite(target)
      return orbitee.trace_route(target, path)
    elsif !satellites.find{|body| body.name == target}
      return satellites.find{|body| body.has_satellite(target)}.trace_route(target, path)
    end
    return path
  end
end

bodies = [Body.new("COM", nil)]
for orbit in orbits
  matches = orbit.match(/(.+)\)(.+)/)
  orbitee = matches[1]
  satellite = matches[2]

  #puts "#{orbit}: #{orbitee} #{satellite}"

  body = bodies.find{|body| body.name == orbitee}
  sat = bodies.find{|body| body.name == satellite}
  if (body == nil)
    body = Body.new(orbitee, nil)
    bodies << body
  end
  if (sat == nil)
    sat = Body.new(satellite, body)
    bodies << sat
  else
    sat.orbitee = body
  end

  body.satellites << sat

#  puts "#{body.to_s}"
end

#puts bodies[0].pretty_print
#puts bodies[0].orbits

route = bodies.find{|body| body.name == "YOU"}.trace_route("SAN")
puts route.to_s
# Don't count YOU->start
puts route.length - 2
