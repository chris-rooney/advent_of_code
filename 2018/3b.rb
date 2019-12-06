# input =
# "#1 @ 1,3: 4x4
# #2 @ 3,1: 4x4
# #3 @ 5,5: 2x2"
input = File.open("input3.txt").read
claims = input.split("\n")

def parse_claim(claim)
  claim_format = /#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/
  matches = claim.match(claim_format)
  return [matches[1].to_i, matches[2].to_i, matches[3].to_i, matches[4].to_i, matches[5].to_i]
end

def fill_grid(grid, id, x, y, w, h)
  #puts "Fill (#{x},#{y}) to (#{x+w}, #{y+h})"
  for i in x...x+w
    for j in y...y+h
      if grid.has_key?([i,j])
        grid[[i,j]] << id
      else
        grid[[i,j]] = [id]
      end
    end
  end
end

fabric_claims = {}
claim_ids = []
for claim in claims
  parsed_claim = parse_claim(claim)
  #puts parsed_claim.to_s
  claim_ids << parsed_claim[0]
  fill_grid(fabric_claims, parsed_claim[0], parsed_claim[1], parsed_claim[2], parsed_claim[3], parsed_claim[4])
  #puts fabric_claims
end

overlap = fabric_claims.select {|key, val| val.length > 1}

#puts claim_ids.to_s
#puts overlap.to_s
overlap.each do |coord, ids|
  claim_ids.reject! {|id| ids.include?(id)}
  #puts claim_ids.to_s
end
puts claim_ids.to_s
