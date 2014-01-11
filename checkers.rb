require_relative 'piece.rb'
require_relative 'board.rb'

class Checkers
  
  attr_reader :board, :current_player
  
  def initialize
    @current_player = :white
    @board = Board.new()
    
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
  end
  
  def over?
    
  end
  
end