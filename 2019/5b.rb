program = [
  #3,9,8,9,10,9,4,9,99,-1,8
  #3,9,7,9,10,9,4,9,99,-1,8
  #3,3,1108,-1,8,3,4,3,99
  #3,3,1107,-1,8,3,4,3,99
  #3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9
  #3,3,1105,-1,9,1101,0,0,12,4,12,99,1
  #3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99
  3,225,1,225,6,6,1100,1,238,225,104,0,1101,72,36,225,1101,87,26,225,2,144,13,224,101,-1872,224,224,4,224,102,8,223,223,1001,224,2,224,1,223,224,223,1102,66,61,225,1102,25,49,224,101,-1225,224,224,4,224,1002,223,8,223,1001,224,5,224,1,223,224,223,1101,35,77,224,101,-112,224,224,4,224,102,8,223,223,1001,224,2,224,1,223,224,223,1002,195,30,224,1001,224,-2550,224,4,224,1002,223,8,223,1001,224,1,224,1,224,223,223,1102,30,44,225,1102,24,21,225,1,170,117,224,101,-46,224,224,4,224,1002,223,8,223,101,5,224,224,1,224,223,223,1102,63,26,225,102,74,114,224,1001,224,-3256,224,4,224,102,8,223,223,1001,224,3,224,1,224,223,223,1101,58,22,225,101,13,17,224,101,-100,224,224,4,224,1002,223,8,223,101,6,224,224,1,224,223,223,1101,85,18,225,1001,44,7,224,101,-68,224,224,4,224,102,8,223,223,1001,224,5,224,1,223,224,223,4,223,99,0,0,0,677,0,0,0,0,0,0,0,0,0,0,0,1105,0,99999,1105,227,247,1105,1,99999,1005,227,99999,1005,0,256,1105,1,99999,1106,227,99999,1106,0,265,1105,1,99999,1006,0,99999,1006,227,274,1105,1,99999,1105,1,280,1105,1,99999,1,225,225,225,1101,294,0,0,105,1,0,1105,1,99999,1106,0,300,1105,1,99999,1,225,225,225,1101,314,0,0,106,0,0,1105,1,99999,7,677,226,224,102,2,223,223,1005,224,329,101,1,223,223,8,677,226,224,1002,223,2,223,1005,224,344,1001,223,1,223,1107,677,677,224,102,2,223,223,1005,224,359,1001,223,1,223,1107,226,677,224,102,2,223,223,1005,224,374,101,1,223,223,7,226,677,224,102,2,223,223,1005,224,389,101,1,223,223,8,226,677,224,1002,223,2,223,1005,224,404,101,1,223,223,1008,226,677,224,1002,223,2,223,1005,224,419,1001,223,1,223,107,677,677,224,102,2,223,223,1005,224,434,101,1,223,223,1108,677,226,224,1002,223,2,223,1006,224,449,101,1,223,223,1108,677,677,224,102,2,223,223,1006,224,464,101,1,223,223,1007,677,226,224,102,2,223,223,1006,224,479,101,1,223,223,1008,226,226,224,102,2,223,223,1006,224,494,101,1,223,223,108,226,226,224,1002,223,2,223,1006,224,509,101,1,223,223,107,226,226,224,102,2,223,223,1006,224,524,101,1,223,223,1107,677,226,224,102,2,223,223,1005,224,539,1001,223,1,223,108,226,677,224,1002,223,2,223,1005,224,554,101,1,223,223,1007,226,226,224,102,2,223,223,1005,224,569,101,1,223,223,8,226,226,224,102,2,223,223,1006,224,584,101,1,223,223,1008,677,677,224,1002,223,2,223,1005,224,599,1001,223,1,223,107,226,677,224,1002,223,2,223,1005,224,614,1001,223,1,223,1108,226,677,224,102,2,223,223,1006,224,629,101,1,223,223,7,677,677,224,1002,223,2,223,1005,224,644,1001,223,1,223,108,677,677,224,102,2,223,223,1005,224,659,101,1,223,223,1007,677,677,224,102,2,223,223,1006,224,674,101,1,223,223,4,223,99,226
]

$sim_inputs = [5]
$sim_input_idx = 0
def getInput()
  input = $sim_inputs[$sim_input_idx]
  $sim_input_idx += 1
  return input
end

def doOutput(data)
  puts "Output: #{data.to_s}"
end

def getParam(opcode, param_idx, raw_param, program)
  op_components = opcode.to_s.split("")
  mode_idx = op_components.length - (2+param_idx)
  #puts "#{opcode}, #{param_idx}, #{mode_idx}"
  mode = mode_idx >= 0 ? op_components[mode_idx].to_i : 0
  #puts "Mode #{mode}"
  return mode > 0 ? raw_param : program[raw_param]
end

def noop(ip, opcode, program)
  # puts "#{opcode}"
  # puts "I guess 0 is NOOP?"
  return ip+1
end

def add(ip, opcode, program)
  # puts "#{opcode}, #{program[ip+1]}, #{program[ip+2]}, #{program[ip+3]}"
  p1 = getParam(opcode, 1, program[ip+1], program)
  p2 = getParam(opcode, 2, program[ip+2], program)
  p3 = program[ip+3]
  # puts "P[#{p3}] = #{p1} + #{p2}"
  calc = p1 + p2
  program[p3] = calc
  return ip+4
end

def multiply(ip, opcode, program)
  # puts "#{opcode}, #{program[ip+1]}, #{program[ip+2]}, #{program[ip+3]}"
  p1 = getParam(opcode, 1, program[ip+1], program)
  p2 = getParam(opcode, 2, program[ip+2], program)
  p3 = program[ip+3]
  # puts "P[#{p3}] = #{p1} * #{p2}"
  calc = p1 * p2
  program[p3] = calc
  return ip+4
end

def input(ip, opcode, program)
  # puts "#{opcode}, #{program[ip+1]}"
  p1 = program[ip+1]
  input = getInput()
  # puts "P[#{p1}] = Input: #{input}"
  program[p1] = input
  return ip+2
end

def output(ip, opcode, program)
  #puts "#{opcode}, #{program[ip+1]}"
  p1 = getParam(opcode, 1, program[ip+1], program)
  #puts "Output #{p1}"
  doOutput(p1)
  return ip+2
end

def jumpIfTrue(ip, opcode, program)
  # puts "#{opcode}, #{program[ip+1]}, #{program[ip+2]}"
  p1 = getParam(opcode, 1, program[ip+1], program)
  p2 = getParam(opcode, 2, program[ip+2], program)
  # puts "IP = #{p1} ? #{p2} : IP+3"
  return p1 != 0 ? p2 : ip + 3
end

def jumpIfFalse(ip, opcode, program)
  # puts "#{opcode}, #{program[ip+1]}, #{program[ip+2]}"
  p1 = getParam(opcode, 1, program[ip+1], program)
  p2 = getParam(opcode, 2, program[ip+2], program)
  # puts "IP = #{p1} ? IP+3 : #{p2}"
  return p1 == 0 ? p2 : ip + 3
end

def lessThan(ip, opcode, program)
  # puts "#{opcode}, #{program[ip+1]}, #{program[ip+2]}, #{program[ip+3]}"
  p1 = getParam(opcode, 1, program[ip+1], program)
  p2 = getParam(opcode, 2, program[ip+2], program)
  p3 = program[ip+3]
  # puts "P[#{p3}] = #{p1} < #{p2}"
  program[p3] = (p1 < p2 ? 1 : 0)
  return ip+4
end

def equals(ip, opcode, program)
  # puts "#{opcode}, #{program[ip+1]}, #{program[ip+2]}, #{program[ip+3]}"
  p1 = getParam(opcode, 1, program[ip+1], program)
  p2 = getParam(opcode, 2, program[ip+2], program)
  p3 = program[ip+3]
  # puts "P[#{p3}] = #{p1} == #{p2}"
  program[p3] = (p1 == p2 ? 1 : 0)
  return ip+4
end

def halt(ip, opcode, program)
  # puts "#{opcode}"
  exit
end

ip=0
until (ip >= program.length)
  #puts "#{ip} #{program[ip]}"

  opcode = program[ip]
  op_components = opcode.to_s.split("")
  #puts op_components.to_s

  instruction = op_components.last(2).join("").to_i
  #puts instruction

  case instruction
  when 0
    ip = noop(ip, opcode, program)
  when 1
    ip = add(ip, opcode, program)
  when 2
    ip = multiply(ip, opcode, program)
  when 3
    ip = input(ip, opcode, program)
  when 4
    ip = output(ip, opcode, program)
  when 5
    ip = jumpIfTrue(ip, opcode, program)
  when 6
    ip = jumpIfFalse(ip, opcode, program)
  when 7
    ip = lessThan(ip, opcode, program)
  when 8
    ip = equals(ip, opcode, program)
  when 99
    ip = halt(ip, opcode, program)
  else
    puts "Invalid opcode! #{ip}:#{instruction}"
    break
  end
end
