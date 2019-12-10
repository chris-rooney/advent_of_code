# input = "Step C must be finished before step A can begin.
# Step C must be finished before step F can begin.
# Step A must be finished before step B can begin.
# Step A must be finished before step D can begin.
# Step B must be finished before step E can begin.
# Step D must be finished before step E can begin.
# Step F must be finished before step E can begin."
input = File.open("input7.txt").read

instructions = input.split("\n")

class Step
  attr_reader :name
  attr_accessor :prereqs
  attr_accessor :executed

  def initialize(name)
    @name = name
    @prereqs = Array.new
    @executed = false
  end

  def pretty_print
    puts "#{name}: [#{prereqs.map(&:name).join(", ")}]"
  end
end

steps = []
instructions.each do |instruction|
  matches = instruction.match(/Step (\w) must be finished before step (\w) can begin./)
  step_name = matches[1]
  prereq_for = matches[2]

  step = steps.find {|step| step.name == step_name}
  prereq_for_step = steps.find {|step| step.name == prereq_for}
  if (step == nil)
    step = Step.new(step_name)
    steps << step
  end
  if (prereq_for_step == nil)
    prereq_for_step = Step.new(prereq_for)
    steps << prereq_for_step
  end
  prereq_for_step.prereqs << step
end

steps.each(&:pretty_print)

sequence = ""
steps.length.times do
  do_step = steps.select{|step| !step.executed && step.prereqs.empty?}.sort_by(&:name).first
  sequence << do_step.name
  do_step.executed = true
  steps.each {|step| step.prereqs.delete(do_step)}
end
puts sequence
