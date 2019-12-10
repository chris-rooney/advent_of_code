# input = "Step C must be finished before step A can begin.
# Step C must be finished before step F can begin.
# Step A must be finished before step B can begin.
# Step A must be finished before step D can begin.
# Step B must be finished before step E can begin.
# Step D must be finished before step E can begin.
# Step F must be finished before step E can begin."
# $base_time = 0
# $workers = Array.new(2, ".")
input = File.open("input7.txt").read
$base_time = 60
$workers = Array.new(5, ".")

instructions = input.split("\n")

class Step
  attr_reader :name
  attr_accessor :prereqs
  attr_accessor :time_spent

  def initialize(name)
    @name = name
    @prereqs = Array.new
    @time_spent = 0
  end

  def time_required
    return $base_time + (1 - 'A'.ord) + name.ord
  end

  def executed
    return time_spent >= time_required
  end

  def pretty_print
    puts "#{name}{#{time_required-time_spent}}: [#{prereqs.map(&:name).join(", ")}]"
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

# steps.each(&:pretty_print)

sequence = ""
seconds = 0
while sequence.length < steps.length do
  ready_steps = steps.select{|step| !step.executed && step.prereqs.empty?}.sort_by(&:name)
  # ready_steps.each(&:pretty_print)
  $workers.each_with_index do |worker, i|
    # Complete current task
    do_step = ready_steps.find{|step| step.name == worker}
    if do_step != nil
      ready_steps.delete(do_step)
    else
      do_step = ready_steps.shift
    end

    if do_step != nil
      $workers[i] = do_step.name
      do_step.time_spent += 1
      if do_step.executed
        sequence << do_step.name
        steps.each {|step| step.prereqs.delete(do_step)}
      end
    else
      $workers[i] = "."
    end
  end
  # puts "#{seconds}: #{$workers}"
  seconds += 1
end
# puts sequence
puts seconds
