inputs =
# "9 ORE => 2 A
# 8 ORE => 3 B
# 7 ORE => 5 C
# 3 A, 4 B => 1 AB
# 5 B, 7 C => 1 BC
# 4 C, 1 A => 1 CA
# 2 AB, 3 BC, 4 CA => 1 FUEL"
# "157 ORE => 5 NZVS
# 165 ORE => 6 DCFZ
# 44 XJWVT, 5 KHKGT, 1 QDVJ, 29 NZVS, 9 GPVTF, 48 HKGWZ => 1 FUEL
# 12 HKGWZ, 1 GPVTF, 8 PSHF => 9 QDVJ
# 179 ORE => 7 PSHF
# 177 ORE => 5 HKGWZ
# 7 DCFZ, 7 PSHF => 2 XJWVT
# 165 ORE => 2 GPVTF
# 3 DCFZ, 7 NZVS, 5 HKGWZ, 10 PSHF => 8 KHKGT"
# "2 VPVL, 7 FWMGM, 2 CXFTF, 11 MNCFX => 1 STKFG
# 17 NVRVD, 3 JNWZP => 8 VPVL
# 53 STKFG, 6 MNCFX, 46 VJHF, 81 HVMC, 68 CXFTF, 25 GNMV => 1 FUEL
# 22 VJHF, 37 MNCFX => 5 FWMGM
# 139 ORE => 4 NVRVD
# 144 ORE => 7 JNWZP
# 5 MNCFX, 7 RFSQX, 2 FWMGM, 2 VPVL, 19 CXFTF => 3 HVMC
# 5 VJHF, 7 MNCFX, 9 VPVL, 37 CXFTF => 6 GNMV
# 145 ORE => 6 MNCFX
# 1 NVRVD => 8 CXFTF
# 1 VJHF, 6 MNCFX => 4 RFSQX
# 176 ORE => 6 VJHF"
# "171 ORE => 8 CNZTR
# 7 ZLQW, 3 BMBT, 9 XCVML, 26 XMNCP, 1 WPTQ, 2 MZWV, 1 RJRHP => 4 PLWSL
# 114 ORE => 4 BHXH
# 14 VRPVC => 6 BMBT
# 6 BHXH, 18 KTJDG, 12 WPTQ, 7 PLWSL, 31 FHTLT, 37 ZDVW => 1 FUEL
# 6 WPTQ, 2 BMBT, 8 ZLQW, 18 KTJDG, 1 XMNCP, 6 MZWV, 1 RJRHP => 6 FHTLT
# 15 XDBXC, 2 LTCX, 1 VRPVC => 6 ZLQW
# 13 WPTQ, 10 LTCX, 3 RJRHP, 14 XMNCP, 2 MZWV, 1 ZLQW => 1 ZDVW
# 5 BMBT => 4 WPTQ
# 189 ORE => 9 KTJDG
# 1 MZWV, 17 XDBXC, 3 XCVML => 2 XMNCP
# 12 VRPVC, 27 CNZTR => 2 XDBXC
# 15 KTJDG, 12 BHXH => 5 XCVML
# 3 BHXH, 2 VRPVC => 7 MZWV
# 121 ORE => 7 VRPVC
# 7 XCVML => 6 RJRHP
# 5 BHXH, 4 VRPVC => 5 LTCX"
File.open("input14.txt").read

class Reaction
  attr_reader :name, :amount
  attr_accessor :reagents

  def initialize(name, amount, reagents)
    @name = name
    @amount = amount
    @reagents = reagents
  end

  def to_s
    return "#{name}: #{reagents.to_s} -> #{amount}"
  end

  def breakdown_reagents(reactions, extras)
    step = {}
    @reagents.each do |k, v|
      if k == "ORE"
        step[k] = step.has_key?(k) ? step[k] + v : v
        next
      end

      reagent_reaction = reactions.find {|reaction| reaction.name == k}
      puts reagent_reaction

      needed = v
      if extras.has_key?(reagent_reaction.name)
        needed -= extras[reagent_reaction.name]
        extras[reagent_reaction.name] = 0
      end
      puts needed

      ratio = Rational(needed, reagent_reaction.amount)
      puts ratio
      extra = ratio.ceil * reagent_reaction.amount - needed
      puts "Extra: #{extra}"
      if extra > 0
        extras[k] = 0 if !extras.has_key?(k)
        extras[k] += extra
      end

      reagent_reaction.reagents.each do |reagent|
        # puts reagent.to_s
        step[reagent[0]] = 0 if !step.has_key?(reagent[0])
        step[reagent[0]] += (ratio.ceil * reagent[1])
        # puts step[reagent[0]]
      end
    end
    @reagents = step
    puts @reagents
    if @reagents.length > 1 || !reagents.has_key?("ORE")
      breakdown_reagents(reactions, extras)
    end
  end
end

reactions = inputs.strip.split("\n").map do |input|
  matches = input.scan(/(\d+) (\w+)/)
  # puts matches.to_s
  components = {}
  for i in 0...(matches.length-1)
    components[matches[i][1]] = matches[i][0].to_i
  end
  result = matches[matches.length-1]
  Reaction.new(result[1], result[0].to_i, components)
end

# puts reactions.to_s

fuel_reaction = reactions.find {|reaction| reaction.name == "FUEL"}
puts fuel_reaction.to_s

extras = {}
fuel_reaction.breakdown_reagents(reactions, extras)
puts fuel_reaction
puts extras.to_s
puts fuel_reaction.reagents["ORE"]
