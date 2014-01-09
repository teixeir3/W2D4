require_relative 'piece.rb'
require 'debugger'


class Board
  attr_accessor :rows

  def default_board(filled)  # Populates default board with "x". MUST ADD Piece Objects.
    default_rows = Array.new(8) { Array.new(8) }

    if filled
      # debugger
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

    default_rows
  end

  def initialize(filled = true)
    @rows = default_board(filled)
  end

  def [](pos)
    # returns piece object at that pos
    x, y = pos[0], pos[1]
    @rows[x][y]
  end

  def []=(pos, piece)
    # be careful using this method since it doesnt' update the piece's pos
    x, y = pos[0], pos[1]
    @rows[x][y] = piece
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

  def dup
    duped_rows = rows.map(&:dup)

    duped_rows.each_with_index do |row, row_idx|
      row.each_index do |col_idx|
        current_cell = duped_rows[row_idx][col_idx]
        next if current_cell.nil?
        duped_rows[row_idx][col_idx] = current_cell.dup
      end
    end
    duped_board = self.class.new(duped_rows)
    duped_board.pieces.each do |piece|
      piece.board = duped_board
    end

    duped_board
  end

  def pieces
    # returns arr of pieces ADD COMPACT
    self.rows.flatten.reject { |cell| cell.nil? }
  end

  def empty?(pos)
    self[pos].nil?
  end

  def add_piece(piece, target_pos) # POTENTIAL PROBLEM
    raise "position is filled" unless self.empty?(target_pos)
    self[target_pos] = piece
  end


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
