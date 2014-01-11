require_relative 'piece.rb'
require_relative 'board.rb'

class Checkers

  attr_reader :board, :current_player

  def initialize(board = Board.new(true))
    @current_player = :white
    @board = board

  end

  def play
    until won? do
      begin
        self.render
        puts "#{@current_player.to_s.capitalize}, enter a move sequence (ex: c6) and hit enter. Press enter when done:"
        turn
      rescue
        retry
      end
      @current_player = (:current_player == :red) ? :white : :red
    end

    nil
  end

  def turn
    move_sequence = get_move_sequence

    raise "No Piece at that location" if @board.empty?(move_sequence[0])
    @board[move_sequence[0]].perform_moves(move_sequence)

  end

  def won?
    # Game is won if the other color doesn't have any pieces
    # Game is won if opponent has no valid moves <-- NOT IMPLEMENTED YET
    opponent_color = (:current_player == :red) ? :red : :white
    @board.pieces.each do |piece|
      return false if piece.color == opponent_color
    end

    return true
  end

  def render
    @board.render
  end

  protected

  def get_move_sequence
    positions = []
    positions << get_pos

    loop do
      target_pos = get_pos

      return positions if target_pos.empty?

      positions << target_pos
    end
  end

  def get_pos
    user_input_arr = gets.chomp.split("").map(&:strip)
    parsed_input = (user_input_arr.empty?) ? [] : parse_input(user_input_arr)
  end

  def parse_input(user_input)
    parsed_input = []

    parsed_input[1], parsed_input[0] = user_input[0].ord-97, user_input[1].to_i-1

    parsed_input
  end
end

if __FILE__ == $PROGRAM_NAME
  g = Checkers.new
  g.play
end
