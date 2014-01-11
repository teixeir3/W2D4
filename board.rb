require_relative 'piece.rb'
require 'debugger'

class InvalidMoveError < StandardError
end

class Board
  attr_accessor :grid

  # def default_board(filled)
#     default_rows =
#
#
#     default_rows = fill_rows(default_rows) if filled
#     #   default_rows = default_rows.each_with_index do |row, x|
#     #     next if x.between?(3, 4)
#     #     color = :red if x.between?(0, 2)
#     #     color = :white if x.between?(5, 7)
#     #     row.each_index do |y|
#     #       if x.even?
#     #         next if y.even?
#     #         default_rows[x][y] = Piece.new(self, color, [x, y])
#     #       else
#     #         next unless y.even?
#     #         default_rows[x][y] = Piece.new(self, color, [x, y])
#     #       end
#     #     end
#     #   end
#     # end
#
#     default_rows
#   end

  def initialize(filled = true)
    @grid = Array.new(8) { Array.new(8) }

    fill_rows if filled
  end

  def fill_rows
    @grid = @grid.each_with_index do |row, x|
        next if x.between?(3, 4)
        color = :red if x.between?(0, 2)
        color = :white if x.between?(5, 7)
        row.each_index do |y|
          if x.even?
            next if y.even?
            @grid[x][y] = Piece.new(self, color, [x, y])
          else
            next unless y.even?
            @grid[x][y] = Piece.new(self, color, [x, y])
          end
        end
      end

    nil
  end

  def [](pos)
    # returns piece object at that pos
    x, y = pos[0], pos[1]
    @grid[x][y]
  end

  def []=(pos, piece)
    # be careful using this method since it doesnt' update the piece's pos
    x, y = pos[0], pos[1]
    @grid[x][y] = piece
  end

  def move(start_pos, end_pos)
    start_piece = self[start_pos]
    start_piece.pos = end_pos
    self[start_pos] = nil
    self[end_pos] = start_piece

    self
  end

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

  # Make this shorter and more clear
  def dup
    empty_board = Board.new
    pieces.each do |piece|
      temp_color = (piece.color == :red) ? :red : :white
      temp_pos = [piece.pos[0], piece.pos[1]]
      temp_kinged = piece.kinged
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

  def pieces
    self.rows.flatten.compact
  end

  def empty?(pos)
    self[pos].nil?
  end

  def add_piece(piece, target_pos) # DOESN'T WORK BUGGY
    # if self.empty?(target_pos)
#       puts self.empty?(target_pos)
#     end
    self[target_pos] = piece
  end


  def render
    print "  "
    ("a".."h").each { |letter| print "#{letter}" }
    puts
    @grid.each_with_index do |row, i|
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

end
