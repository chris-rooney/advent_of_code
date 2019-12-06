input1=153517
input2=630395
test_inputs=[112233, 123444, 111122]

def check_adjacency(password)
  adjacency = /\d*(\d)\1\d*/
  password.to_s =~ adjacency
end


def check_strict_adjacency(password)
  # Can't seem to get a regex that does lookahead AND assesses multiple instances
  adjacency = /(\d)\1+/
  if password =~ adjacency
    # puts password
    matches = password.enum_for(:scan, adjacency).map { Regexp.last_match.begin(0) }
    for i in matches
      if (i + 2) > password.length
        return true
      end
      val = password[i]
      overflow = password[i+2]
      # puts "#{i}: #{val} #{overflow}"
      if val != overflow
        return true
      end
    end
  end
  return false
end

def check_monotonic(password)
  digits = password.to_s.chars.map(&:to_i)
  for i in 1...digits.length
    if digits[i] < digits[i-1]
      return false
    end
  end
  return true
end

count = 0
#for i in test_inputs
for i in input1 ... input2
  if check_strict_adjacency(i.to_s) && check_monotonic(i)
    count += 1
  end
end
puts count
