
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

  attr_accessor :kinged, :pos
  attr_reader :color, :board


  def initialize(board, color, pos, kinged = false)
    #add errors if off board or wrong color
    @board, @color, @pos, @kinged = board, color, pos, kinged

    @token = (@color == :red) ? :r : :w

    board.add_piece(self, pos)
  end

  def move_diffs
    DIAGONAL_DIRS.values
  end

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
    @board.move(start_pos, end_pos)

    maybe_promote

    true
  end


  def perform_jump(start_pos, end_pos)
    # check if legal
    # illegal move returns false
    # removes jumped piece from the board
    cur_move_diff = (end_pos[0] - start_pos[0]), (end_pos[1] - start_pos[1])

    # should raise error
    return false unless @board.empty?(end_pos)
    return false unless jump_diffs.include?(cur_move_diff)

    direction = JUMP_DIRS.key(cur_move_diff)
    unless @kinged
      if color == white
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

  def maybe_promote
    self.kinged = true if on_opposite_side?
  end

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
    # move_sequence can either be one slide, or 1+ jmps
    # if sequence is 1 move long, try sliding, if fail, try jumping
    # if sequence > 1, try jumping until sequence has no more moves or one move fails

    # performs moves 1 by 1, raises InvalidMoveError if fails

  end

  def valid_move_seq?
    # calls perform_moves! on duped piece/board
    # if perform_moves! doesn't return raise error, return true
    # else, false

    # will require: begin, rescue, else
    # dups objects and doesn't modify original board

  end

  def perform_moves
    # first check valid_move_seq?
    # if valid_move_seq?
    # perform_moves!
    # else
    # raise InvalidMoveError
  end

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