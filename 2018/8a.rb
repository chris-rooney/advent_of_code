# input = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"
input = File.open("input8.txt").read.strip

class Node
  attr_reader :num_children, :num_metadata
  attr_accessor :children, :metadata

  def initialize(num_children, num_metadata)
    @num_children = num_children
    @num_metadata = num_metadata
    @children = []
    @metadata = []
  end

  def pretty_print(depth=0)
    indent = "\t"*depth
    puts "#{indent}M=#{num_metadata}:#{metadata.to_s}"
    puts "#{indent}C=#{num_children}:["
    children.each {|child| child.pretty_print(depth+1)}
    puts "#{indent}]"
  end

  def sum_metadata
    return metadata.reduce(0, :+) + children.reduce(0) {|sum, child| sum + child.sum_metadata}
  end

  def value
    if children.empty?
      return sum_metadata
    else
      return metadata.reduce(0) {|sum, i| sum + (children[i-1]&.value || 0)}
    end
  end
end

def read_node(stream)
  num_children = stream.shift
  num_metadata = stream.shift
  node = Node.new(num_children, num_metadata)

  num_children.times do
    node.children << read_node(stream)
  end
  num_metadata.times do
    node.metadata << stream.shift
  end
  return node
end

stream = input.split(" ").map(&:to_i)
root = read_node(stream)
#root.pretty_print
puts "Part One: #{root.sum_metadata}"
puts "Part Two: #{root.value}"
