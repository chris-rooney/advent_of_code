# input = "0222112222120000"
# width = 2
# height = 2

input = File.open("input8.txt").read
width = 25
height = 6

layers = input.scan(/.{#{width*height}}/).map{|flattened_layer| flattened_layer.scan(/.{#{width}}/)}
#puts layers.to_s

rendered = layers.shift
layers.each do |layer|
  # puts layer.to_s
  layer.each_with_index do |row, i|
    row.each_char.with_index do |cell, j|
      if rendered[i][j] == "2"
        rendered[i][j] = cell
      end
    end
  end
end

rendered.each do |row|
  puts row.gsub("1", " ")
end
