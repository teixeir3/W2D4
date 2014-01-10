require 'debugger'

class InvalidMoveError < StandardError
end

class InvalidSequenceError < StandardError
end

class Piece

  UNICODES = {
    :r_king => "\u2689",
    :r_piece => "\u2688",
    :w_king => "\u2687",
    :w_piece => "\u2686"
  }

  DIAGONAL_DIRS = {
     :nw => [-1, -1],
     :ne => [-1,  1],
     :sw =>  [ 1, -1],
     :se => [ 1,  1]
    }

  JUMP_DIRS = {
      :nw => [-2, -2],
      :ne => [-2,  2],
      :sw =>  [ 2, -2],
      :se => [ 2,  2]
    }

  attr_accessor :kinged, :pos, :board
  attr_reader :color

  # REV: good!
  def initialize(board, color, pos, kinged = false)
    #add errors if off board or wrong color
    @board, @color, @pos, @kinged = board, color, pos, kinged

    @token = (@color == :red) ? :r : :w

    board.add_piece(self, pos)
  end

  def move_diffs
    DIAGONAL_DIRS.values
  end

  # REV: nifty to have move_diffs and jump_diffs as two different methods
  def jump_diffs
    JUMP_DIRS.values
  end

  def perform_slide(start_pos, end_pos)
    # could make move_diff helper method
    cur_move_diff = (end_pos[0] - start_pos[0]), (end_pos[1] - start_pos[1])

    # could make invalid_move? helper method

    # should raise error
    return false unless move_diffs.include?(cur_move_diff)
    return false unless @board.empty?(end_pos)

    direction = DIAGONAL_DIRS.key(cur_move_diff)

    # Only kings to move north and south
    # REV: I implemented a whole other hash key for kings to get their moves from but this is fine too
    # ex) MOVES = {
    #   [:black, false] => [[1, -1], [1, 1]],
    #   [:red, false] => [[-1, -1], [-1, 1]],
    #   :king => [[-1, -1], [-1, 1], [1, -1], [1, 1]]
    #   }
    unless @kinged
      if color == :white
        return false if direction.to_s[0] == "s"
      elsif color == :red
        return false if direction.to_s[0] == "n"
      end
    end

    @board.move(start_pos, end_pos)

    maybe_promote

    true
  end

  # REV: consider breaking this down a bit but it seems to work
  def perform_jump(start_pos, end_pos)
    cur_move_diff = (end_pos[0] - start_pos[0]), (end_pos[1] - start_pos[1])

    # should raise error
    return false unless @board.empty?(end_pos)
    return false unless jump_diffs.include?(cur_move_diff)

    direction = JUMP_DIRS.key(cur_move_diff)

    # Only kings to move north and south
    unless @kinged
      if color == :white
        return false if direction.to_s[0] == "s"
      elsif color == :red
        return false if direction.to_s[0] == "n"
      end
    end

    # shorten this later.
    jumped_square = [DIAGONAL_DIRS[direction][0] + start_pos[0], DIAGONAL_DIRS[direction][1] + start_pos[1]]

    return false if @board[jumped_square].nil?
    return false if @board[jumped_square].color == @color

    @board[jumped_square] = nil
    @board.move(start_pos, end_pos)
    maybe_promote

    true
  end
  
  # REV: I like how this calls another helper method and ends up being a one-liner
  def maybe_promote
    self.kinged = true if on_opposite_side?
  end

  # REV: this might be able to be shortened
  # ex) (@color == :red && @pos[0] == 0) || (@color == :black && @pos[0] == (@board.n - 1))
  def on_opposite_side?
    if @color == :red && @pos[0] == 7
      return true
    elsif @color == :white && @pos[0] == 0
      return true
    end

    false
  end

  def perform_moves!(move_sequence)
    # takes a sequence of moves
    if move_sequence.count % 2 != 0
      raise InvalidMoveError
    elsif move_sequence.count == 2
      # make a sliding move
      start_pos = move_sequence.shift
      end_pos = move_sequence.shift
      unless perform_slide(start_pos, end_pos)
        raise InvalidMoveError unless perform_jump(start_pos, end_pos)
      end
    elsif move_sequence.count > 2
      # make jumping moves until you're out of moves.
      while move_sequence.count > 0
        start_pos = move_sequence.shift
        end_pos = move_sequence.shift
        raise InvalidMoveError unless perform_jump(start_pos, end_pos)
      end
    end

    nil
  end
  
  # couldn't you just do dup_board = board.dup
  # and then something like: dup_board[@pos].perform_moves!(sequence)
  # as opposed to duping the position and the piece
  def valid_move_seq?(move_sequence)
    dup_pos = @pos
    dup_board = @board.dup
    dup_piece = Piece.new(dup_board, @color, dup_pos)

    begin
      dup_piece.perform_moves!(move_sequence)
    rescue InvalidMoveError => e
      return false
    # else true
    end

    true
  end

  # REV: this could be simplified into something like: 
  # -raise InvalidMoveError if valid_move_seq?(sequence) == false
  # -perform_moves!(sequence)
  def perform_moves(move_sequence)
    duplicate_seq= move_sequence.map(&:dup)

    if valid_move_seq?(duplicate_seq)
      perform_moves!(move_sequence)
    else
      raise InvalidMoveError
    end

    nil
  end

  # REV: some ternary statements could shorten this method up a bit
  # ex) if color == :red
  # => puts (@kinged ? UNICODES[:r_king] : UNICODES[:r_piece]) --> this ternary with puts should work although i'm not 100%
  # etc. etc.
  def render
    if color == :red
      if @kinged
        print UNICODES[:r_king]
      else
        print UNICODES[:r_piece]
      end
    else
      if @kinged
        print UNICODES[:w_king]
      else
        print UNICODES[:w_piece]
      end
    end
  end

end