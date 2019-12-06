#input = "dabAcCaCBAcCcaDA"
input = File.open("input5.txt").read.strip

def react(polymer)
  #puts polymer
  reacted = false
  i = 0
  while i < polymer.length - 1
    #puts "#{polymer[i]} ~ #{polymer[i+1]}: #{polymer[i].casecmp(polymer[i+1])}"
    if (polymer[i].casecmp(polymer[i+1]) == 0) && polymer[i] != polymer[i+1]
      polymer.slice!(i..i+1)
      reacted = true
    end
    i+=1
  end
  #puts polymer
  return reacted ? react(polymer) : polymer
end

#puts input
reacted = react(input)
#puts reacted
puts reacted.length
