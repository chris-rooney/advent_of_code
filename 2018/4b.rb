# input = File.open("input4_test.txt").read
input = File.open("input4.txt").read

records = input.split("\n").sort
# puts records

def get_minute(record)
  time = /(\d{2}):(\d{2})/
  matches = record.match(time)
  hour = matches[1]
  minute = matches[2]
  # We don't care if they got on shift early
  return hour == "00" ? minute.to_i : 0
end

guard = nil
last_minute = 0
guard_minutes = {}
for record in records
  #puts record
  minute = get_minute(record)
  #puts minute
  if record =~ /falls asleep/
    last_minute = minute
  elsif record =~ /wakes up/
    if !guard_minutes.has_key?(guard)
      guard_minutes[guard] = {}
    end
    minutes = guard_minutes[guard]
    for i in last_minute...minute
      if minutes.has_key?(i)
        minutes[i] += 1
      else
        minutes[i] = 1
      end
    end
  else
    matches = record.match(/Guard #(\d+)/)
    guard = matches[1].to_i
    last_minute = minute
  end
end
#puts guard_minutes

sleepy = [0,0,0]
guard_minutes.each do |guard, minutes|
  max = minutes.inject(0) {|max, kv| max > kv[1] ? max : kv[1]}
  max_min = minutes.key(max)
  if max > sleepy[1]
    sleepy = [guard, max, max_min]
    puts sleepy.to_s
  end
end
puts "#{sleepy[0]} * #{sleepy[2]} = #{sleepy[0] * sleepy[2]}"
