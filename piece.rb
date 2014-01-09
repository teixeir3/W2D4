
class Piece

  DIAGONAL_DIRS = {
     :up_left => [-1, -1],
     :up_right => [-1,  1],
     :down_left =>  [ 1, -1],
     :down_right => [ 1,  1]
    }


  attr_accessor :king
  attr_reader :color
  attr_reader :board


  def initialize(board, color, pos, king = false)
    #add errors if off board or wrong color
    @board, @color, @pos, @king = board, color, pos, king

    @token = (@color == :red) ? :r : :w

    board.add_piece(self, pos)
  end

  def move_diffs
    DIAGNAL_DIRS.values
  end

  def perform_slide(start_pos, end_pos)
    # check if legal (is included in #move_diffs array)
    # illegal move returns false
    cur_move_diff = (end_pos[0]-start_pos[0]), (end_pos[1]-start_pos[1])

    # could make invalid_move? helper method
    return false unless move_diffs.include?(cur_move_diff)
    return false unless @board.empty?(end_pos)
    @board.move(start_pos, end_pos)

    # possibly promote, call #maybe_promote
    true
  end

  def perform_jump(start_pos, end_pos)
    # check if legal
    # illegal move returns false
    # possibly promote, call #maybe_promote
    # removes jumped piece from the board
  end

  def maybe_promote

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




end