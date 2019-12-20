# Doesn't work yet, much too slow. Need a break and come back to wrap my head around how the optimizations discussed online work

input =
# "12345678"
# "11112345"
# "03036732577212944063491565474664" * 10_000
"19617804207202209144916044189917"
# "69317163492948606335995924319873"
# "59723517898690342336085619027921111260000667417052529433894092649779685557557996383085708903241535436786723718804155370155263736632861535632645335233170435646844328735934063129720822438983948765830873108060969395372667944081201020154126736565212455403582565814037568332106043336657972906297306993727714730061029321153984390658949013821918352341503629705587666779681013358053312990709423156110291835794179056432958537796855287734217125615700199928915524410743382078079059706420865085147514027374485354815106354367548002650415494525590292210440827027951624280115914909910917047084328588833201558964370296841789611989343040407348115608623432403085634084"

signal = input.split("").map(&:to_i)
phases = 100
@base_pattern = [0, 1, 0, -1]

def pattern_for_round(round)
  return [0] if round == 0
  @base_pattern.flat_map{|d| Array.new(round, d)}
end

def flawed_frequency_transmission(signal)
  signal.each_with_index.map { |_, i|
    pattern = pattern_for_round(i+1)
    signal.each_with_index.reduce(0){|sum, (d, j)|
      sum + d * pattern[(j+1) % pattern.length]
    }.abs % 10
  }
end

def digit(signal, i, phase)
  # puts "Uhh #{i}"
  if phase == 0
    # puts "Root #{signal[i]}"
    return signal[i]
  end

  # puts "#{phase}: #{i} vs #{(signal.length / 2)}"
  if i >= (signal.length / 2)
    return (i...signal.length).reduce(0) {|sum, j| (sum + digit(signal, j, phase-1)) % 10}
  else
    puts "lol i dunno"
    return -1
  end
end

puts "0: #{signal.length}"
# puts digit(signal, 7, phases)
# puts digit(signal, 6, phases)
# puts digit(signal, 5, phases)
# puts digit(signal, 4, phases)
offset = 20
# offset = input[0...7].to_i
# puts offset
times = []
for i in 1..phases
  t0 = Time.now
  signal = flawed_frequency_transmission(signal)
  times << Time.now - t0
  puts "#{i}: #{signal.to_s}"
end
puts times.reduce(0, :+)
puts "Final: #{signal.join}"
puts (offset...offset+8).map{|i| digit(signal, i, phases)}.to_s
