# input = "+1, -2, +3, +1"
input = File.open("input1.txt").read

# changes = input.split(", ")
changes = input.split("\n")
puts changes.to_s

change = /([+-])(\d+)/
frequency = 0
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
end
puts frequency
