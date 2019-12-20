input =
# "12345678"
# "80871224585914546619083218645595"
# "19617804207202209144916044189917"
# "69317163492948606335995924319873"
"59723517898690342336085619027921111260000667417052529433894092649779685557557996383085708903241535436786723718804155370155263736632861535632645335233170435646844328735934063129720822438983948765830873108060969395372667944081201020154126736565212455403582565814037568332106043336657972906297306993727714730061029321153984390658949013821918352341503629705587666779681013358053312990709423156110291835794179056432958537796855287734217125615700199928915524410743382078079059706420865085147514027374485354815106354367548002650415494525590292210440827027951624280115914909910917047084328588833201558964370296841789611989343040407348115608623432403085634084"

signal = input.split("").map(&:to_i)
phases = 100
@base_pattern = [0, 1, 0, -1]


def pattern_for_round(round, match_length)
  repeats = Rational(match_length, @base_pattern.length).ceil + 1
  (@base_pattern.flat_map{|d| Array.new(round, d)} * repeats).drop(1)
end

def flawed_frequency_transmission(signal)
  output = []
  for i in 1..signal.length
    raw = signal.zip(pattern_for_round(i, signal.length)).map{|d, p|
      # puts "#{d} * #{p}"
      d * p
    }.reduce(0, :+)
    # puts "Raw: #{raw}"
    output << raw.abs % 10
  end
  output
end

times = []
for i in 1..phases
  t0 = Time.now
  signal = flawed_frequency_transmission(signal)
  times << Time.now - t0
  puts "#{i}: #{times.last}"
end
puts times.reduce(0, :+)
puts "Final: #{signal[0...8].join}"
