require_relative 'piece.rb'
require_relative 'board.rb'

class Checkers

  attr_reader :board, :current_player

  def initialize(board = Board.new(true))
    @current_player = :white
    @board = board

  end

  def play

    # Take turns until over?


  end

  def turn

  end

  def won?(color)
    # Game is won if the other color doesn't have any pieces
    # Game is won if opponent has no valid moves
    #

    # if current_player
  end

  def over?

  end

  def get_move_sequence
    positions = []





    positions
  end

  def get_pos
    user_input_arr = gets.chomp.split(",").map(&:strip)
    parsed_input = parse_input(user_input_arr)


  end

  def parse_input(user_input)
    parsed_input = []
    p user_input
    parsed_input[0], parsed_input[1] = user_input[0].ord-97, user_input[1].to_i-1
    parsed_input
  end
end

if __FILE__ == $PROGRAM_NAME
  g = Game.new
  g.play
end
