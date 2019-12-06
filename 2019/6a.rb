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
# K)L"
input = File.open("input6.txt").read

orbits = input.split("\n")
# .shuffle
# puts orbits.to_s

class Body
  attr_reader :name
  attr_accessor :satellites

  def initialize(name)
    @name = name
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
    puts "#{"\t"*tabs}#{name}: #{orbits} ["
    satellites.each{|sat| sat.pretty_print(tabs+1)}
    puts "#{"\t"*tabs}]"
  end
end

bodies = [Body.new("COM")]
for orbit in orbits
  matches = orbit.match(/(.+)\)(.+)/)
  orbitee = matches[1]
  satellite = matches[2]

  #puts "#{orbit}: #{orbitee} #{satellite}"

  body = bodies.find{|body| body.name == orbitee}
  sat = bodies.find{|body| body.name == satellite}
  if (body == nil)
    body = Body.new(orbitee)
    bodies << body
  end
  if (sat == nil)
    sat = Body.new(satellite)
    bodies << sat
  end

  body.satellites << sat

#  puts "#{body.to_s}"
end

#puts bodies[0].pretty_print
puts bodies[0].orbits
