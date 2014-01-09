
class Piece

  attr_accessor :king
  attr_reader :color


  def initialize(board, color, king = false)
    @king = king
    @color = color

  end

  def move_diffs

  end

  def perform_slide

  end

  def perform_jump
    # check if legal
    # illegal move returns false
    # possibly promote, call #maybe_promote
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