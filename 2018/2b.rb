# input =
# "abcde
# fghij
# klmno
# pqrst
# fguij
# axcye
# wvxyz"
input = File.open("input2.txt").read

ids = input.split("\n")
#puts ids.to_s

for i in 0...ids.length
  for j in i+1...ids.length
    id0 = ids[i]
    id1 = ids[j]
    #puts "#{id0},#{id1}"
    diff = []
    for k in 0...id0.length
      char0 = id0[k]
      char1 = id1[k]
      if char0 != char1
        diff << k
      end
    end
    #puts "Diffs #{diff}"
    if diff.length == 1
      #puts "#{id0},#{id1}"
      puts id0[0..diff[0]-1] + id0[diff[0]+1..id0.length]
      exit
    end
  end
end
