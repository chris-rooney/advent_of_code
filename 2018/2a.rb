# input =
# "abcdef
# bababc
# abbcde
# abcccd
# aabcdd
# abcdee
# ababab"
input = File.open("input2.txt").read

ids = input.split("\n")
puts ids.to_s

def char_counts(id)
  char_counts = {}
  for c in id.chars
    if char_counts.has_key?(c)
      char_counts[c] += 1
    else
      char_counts[c] = 1
    end
  end
  return char_counts
end

def check_three(id)
  return true
end

twosies = 0
threesies = 0
for id in ids
  char_counts = char_counts(id)
  if char_counts.any? { |key, val| val == 2 }
    twosies += 1
  end
  if char_counts.any? { |key, val| val == 3 }
    threesies += 1
  end
end
puts "#{twosies} * #{threesies} = #{twosies * threesies}"
