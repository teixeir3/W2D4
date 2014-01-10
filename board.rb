require_relative 'piece.rb'
require 'debugger'

class InvalidMoveError < StandardError
end

class Board
  attr_accessor :rows

  # REV: This method is a bit verbose. 
  # 
  # what I would consider is running an each loop through [0,1,2,5,6,7]
  # and then running a while loop through each of those where you increment a value "i" by 2 each time
  # 
  # Also- you can do x.even? instead of x == 0 || x % 2 == 0 -- 0.even? returns true ;)
  def default_board(rows = nil, filled)  # Populates default board with "x". MUST ADD Piece Objects.
    default_rows = Array.new(8) { Array.new(8) }

    if rows
      default_rows = rows
    else
      if filled
        default_rows = default_rows.each_with_index do |row, x|
          next if x.between?(3, 4)
          color = :red if x.between?(0, 2)
          color = :white if x.between?(5, 7)
          row.each_index do |y|
            if x == 0 || x % 2 == 0
              next if y % 2 == 0
              default_rows[x][y] = Piece.new(self, color, [x, y])
            else
              next unless y % 2 == 0
              default_rows[x][y] = Piece.new(self, color, [x, y])
            end
          end
        end
      end
    end

    default_rows
  end
  
  # REV: this is good
  def initialize(rows = nil, filled = false)
    @rows = default_board(rows, filled)
  end

  # REV: this is good
  def [](pos)
    # returns piece object at that pos
    x, y = pos[0], pos[1]
    @rows[x][y]
  end
  
  # REV: this is good
  def []=(pos, piece)
    # be careful using this method since it doesnt' update the piece's pos
    x, y = pos[0], pos[1]
    @rows[x][y] = piece
  end
  
  # REV: good. does it need to return anything?
  def move(start_pos, end_pos)
    start_piece = self[start_pos]
    start_piece.pos = end_pos
    self[start_pos] = nil
    self[end_pos] = start_piece

    self
  end

  # REV: I like how you have a destructive version as well which raises an error
  # Does it need to return self? I haven't read the entire code at this point so I may be wrong.
  def move!(start_pos, end_pos)
    start_piece = self[start_pos]
    if start_piece.moves.include?(end_pos)
      start_piece.pos = end_pos
      self[start_pos] = nil
      self[end_pos] = start_piece
    else
      raise InvalidMoveError
    end

    self
  end

  # REV: 
  def dup
    empty_board = Board.new
    pieces.each do |piece|
      temp_color = (piece.color == :red) ? :red : :white # REV: Couldn't you just do temp_color = piece.color
      temp_pos = [piece.pos[0], piece.pos[1]] # REV: Couldn't you just do temp_pos = piece.pos
      temp_kinged = piece.kinged # REV: this is good
      temp_piece = Piece.new(empty_board, temp_color, temp_pos, temp_kinged)

      # empty_board.add_piece(Piece.new(empty_board, temp_color, temp_pos, temp_kinged), temp_pos)
    end

    empty_board
    # duped_rows = rows.map(&:dup)
  #
  #   duped_rows.each_with_index do |row, row_idx|
  #     row.each_index do |col_idx|
  #       next if duped_rows[row_idx].nil?
  #       current_cell = duped_rows[row_idx][col_idx]
  #
  #       next if current_cell.nil?
  #       duped_rows[row_idx][col_idx] = current_cell.dup
  #     end
  #   end
  #   duped_board = self.class.new(duped_rows, false)
  #   duped_board.pieces.each do |piece|
  #     piece.board = duped_board
  #   end
  #   duped_board

  end

  # REV: woohoo!
  def pieces
    self.rows.flatten.compact
  end

  # REV: woohoo!
  def empty?(pos)
    self[pos].nil?
  end

  # REV: woohoo although not sure how necessary this method is
  def add_piece(piece, target_pos) # DOESN'T WORK BUGGY
    # if self.empty?(target_pos)
#       puts self.empty?(target_pos)
#     end
    self[target_pos] = piece
  end

  # REV: render inevitably gets more complicated when you print
  # unicode and all the stuff on the side. I feel like this could be 
  # simplified just a bit.
  def render
    print "  "
    ("a".."h").each { |letter| print "#{letter}" }
    puts
    @rows.each_with_index do |row, i|
      print "#{i+1} "
      row.each do |cell|
        if cell.nil?
          # Maybe add unicode for blank squares
          print "\u25FB"
        else
          print cell.render
        end
      end
      puts
    end

    nil
  end

  ############### REMNANTS OF CHESS BOARD #######################

  # class FatalBoardError < StandardError
  # end
  #
  # def in_check?(color)
  #   king_pos = find_king(color)
  #   pieces.any? { |piece| piece.moves.include?(king_pos) }
  # end
  #
  # def checkmate?(color)
  #   players_pieces = pieces.select { |piece| piece.color == color }
  #   in_check?(color) && players_pieces.none? {|piece| piece.valid_moves.length > 0 }
  # end

  # def find_king(color)
  #   @rows.each_index do | row_idx |
  #     king_idx = self.rows[row_idx].index { |cell| cell.class == King }
  #     if king_idx
  #       return [row_idx, king_idx] if self[[row_idx, king_idx]].color == color
  #     end
  #   end
  #   raise FatalBoardError
  # end
  ###################################################################

end
