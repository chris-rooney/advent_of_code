# num_players = 9; last_marble = 25
# num_players = 10; last_marble = 1618
# num_players = 13; last_marble = 7999
# num_players = 17; last_marble = 1104
# num_players = 21; last_marble = 6111
# num_players = 30; last_marble = 5807

# Puzzle Input
num_players = 438; last_marble = 7162600

players = Array.new(num_players) {|i| 0}
# puts players.to_s

class Marble
  attr_reader :score
  attr_accessor :prev_marble, :next_marble

  def initialize(score, prev_marble, next_marble)
    @score = score
    @prev_marble = prev_marble
    @next_marble = next_marble
  end

  def print_from(val=score)
    if @score != val
      next_marble.print_from(val)
    else
      print "[#{@score}"
      next_marble.print_ring(@score)
      print "]\n"
    end
  end

  def print_ring(stop_val)
    if @score != stop_val
      print ", #{@score}"
      next_marble.print_ring(stop_val)
    end
  end
end

cur_marble = Marble.new(0, nil, nil)
cur_marble.prev_marble = cur_marble
cur_marble.next_marble = cur_marble

p_idx = 0
# Then, each Elf takes a turn placing the lowest-numbered remaining marble into the circle
for m in 1..last_marble
  # cur_marble.print_from(0)
  # between the marbles that are 1 and 2 marbles clockwise of the current marble.
  # (When the circle is large enough, this means that there is one marble between the marble that was just placed and the current marble.)
  # The marble that was just placed then becomes the current marble.
  if m % 23 != 0
    # puts "Between #{cur_marble.next_marble.score} and #{cur_marble.next_marble.next_marble.score}"
    new_marble = Marble.new(m, cur_marble.next_marble, cur_marble.next_marble.next_marble)
    cur_marble.next_marble.next_marble.prev_marble = new_marble
    cur_marble.next_marble.next_marble = new_marble
    cur_marble = new_marble
    # puts "Added marble #{m} at position #{m_idx}"
  else
    # However, if the marble that is about to be placed has a number which is a multiple of 23, something entirely different happens.
    # First, the current player keeps the marble they would have placed, adding it to their score.
    players[p_idx] += m
    # In addition, the marble 7 marbles counter-clockwise from the current marble is removed from the circle and also added to the current player's score.
    # The marble located immediately clockwise of the marble that was removed becomes the new current marble.
    cur_marble = cur_marble.prev_marble
        .prev_marble
        .prev_marble
        .prev_marble
        .prev_marble
        .prev_marble
    # puts "Player #{p_idx} kept marble #{m} and took marble #{cur_marble.prev_marble.score}"
    players[p_idx] += cur_marble.prev_marble.score
    cur_marble.prev_marble.prev_marble.next_marble = cur_marble
    cur_marble.prev_marble = cur_marble.prev_marble.prev_marble
  end
  p_idx = (p_idx + 1) % num_players
  # puts p_idx
end

# cur_marble.print_from
puts players.to_s
puts players.max
