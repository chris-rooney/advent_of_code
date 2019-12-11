# input = "123456789012"
# width = 3
# height = 2

input = File.open("input8.txt").read
width = 25
height = 6

layers = input.scan(/.{#{width*height}}/).map{|flattened_layer| flattened_layer.scan(/.{#{width}}/)}
puts layers.to_s

checksum_layer = layers.min{|a,b| a.join("").count("0") <=> b.join("").count("0")}
puts checksum_layer.to_s

puts checksum_layer.join("").count("1") * checksum_layer.join("").count("2")
