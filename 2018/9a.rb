# num_players = 9; last_marble = 25
num_players = 10; last_marble = 70 #1618
# num_players = 13; last_marble = 7999
# num_players = 17; last_marble = 1104
# num_players = 21; last_marble = 6111
# num_players = 30; last_marble = 5807

# Puzzle Input
# num_players = 438; last_marble = 71626

players = Array.new(num_players) {|i| 0}
# puts players.to_s

marbles = [0, 1]
m_idx = 1
p_idx = 1

# Then, each Elf takes a turn placing the lowest-numbered remaining marble into the circle
for m in 2..last_marble
  # between the marbles that are 1 and 2 marbles clockwise of the current marble.
  # (When the circle is large enough, this means that there is one marble between the marble that was just placed and the current marble.)
  # The marble that was just placed then becomes the current marble.
  if m % 23 != 0
    m_idx = (m_idx + 2) % marbles.length
    # puts m_idx
    marbles.insert(m_idx, m)
    # puts "Added marble #{m} at position #{m_idx}"
  else
    # However, if the marble that is about to be placed has a number which is a multiple of 23, something entirely different happens.
    # First, the current player keeps the marble they would have placed, adding it to their score.
    players[p_idx] += m
    # In addition, the marble 7 marbles counter-clockwise from the current marble is removed from the circle and also added to the current player's score.
    # The marble located immediately clockwise of the marble that was removed becomes the new current marble.
    m_idx -= 7 # Ruby arrays can handle negative indices so don't need to modulo
    # puts m_idx
    # puts "Player #{p_idx} kept marble #{m} and took marble #{marbles[m_idx]}"
    players[p_idx] += marbles.delete_at(m_idx)
  end
  puts marbles.rotate(marbles.index(0)).to_s
  p_idx = (p_idx + 1) % num_players
  # puts p_idx
end
puts players.to_s
puts players.max
