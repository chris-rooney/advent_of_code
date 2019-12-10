class Intcode

  attr_accessor :program
  attr_accessor :inputs
  attr_reader :outputs
  attr :ip
  attr :paused

  def initialize(program, inputs=[])
    @program = program
    @inputs = inputs
    @outputs = []
    @ip=0
    @paused=false
  end

  def getInput()
    # TODO run() w/ debug flag
    # puts "getInput: #{inputs.to_s}"
    if inputs.empty?
      return nil
    else
      return inputs.shift
    end
  end

  def doOutput(data)
    # puts "Output: #{data}"
    @outputs << data
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
    if input != nil
      # puts "P[#{p1}] = Input: #{input}"
      program[p1] = input
      return ip+2
    else
      pause
      return ip
    end
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

  def pause
    @paused = true
  end

  def queue_input(input)
    @inputs << input
  end

  def resume_with_input(input)
    queue_input(input)
    @paused = false
    return run
  end

  def run
    until (paused)
      #puts "#{ip} #{program[ip]}"

      opcode = program[ip]
      op_components = opcode.to_s.split("")
      #puts op_components.to_s

      instruction = op_components.last(2).join("").to_i
      #puts instruction

      case instruction
      when 0
        @ip = noop(@ip, opcode, program)
      when 1
        @ip = add(@ip, opcode, program)
      when 2
        @ip = multiply(@ip, opcode, program)
      when 3
        @ip = input(@ip, opcode, program)
      when 4
        @ip = output(@ip, opcode, program)
      when 5
        @ip = jumpIfTrue(@ip, opcode, program)
      when 6
        @ip = jumpIfFalse(@ip, opcode, program)
      when 7
        @ip = lessThan(@ip, opcode, program)
      when 8
        @ip = equals(@ip, opcode, program)
      when 99
        break
      else
        puts "Invalid opcode! #{ip}:#{instruction}"
        break
      end
    end
    ret_outputs = outputs
    outputs = []
    return [paused, ret_outputs]
  end
end
