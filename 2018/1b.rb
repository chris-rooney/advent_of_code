# input = "+1, -1"
# input = "+3, +3, +4, -2, -4"
# input = "-6, +3, +8, +5, -6"
# input = "+7, +7, -2, -7, -4"
input = File.open("input1.txt").read

# changes = input.split(", ")
changes = input.split("\n")
# puts changes.to_s

change = /([+-])(\d+)/
frequency = 0
frequencies = [0]
while(1)
  for c in changes
    matches = c.match(change)
    dir = matches[1]
    amount = matches[2]
    # puts "#{c}: #{dir} #{amount}"
    case dir
    when "+"
      frequency += amount.to_i
    when "-"
      frequency -= amount.to_i
    end
    if (frequencies.include?(frequency))
      puts frequency
      exit
    else
      frequencies << frequency
    end
  end
  puts frequency
end
