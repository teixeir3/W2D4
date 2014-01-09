b[[]].perform_slide([],[])
p = Piece.new(b, :red, [0,1])

UNICODES = {
  :r_king => "\u2689",
  :r_piece => "\u2688",
  :w_king => "\u2687",
  :w_piece => "\u2686"
}

start_pos = [0,0]
end_pos = [1,1]
cur_move_diff = (end_pos[0]-start_pos[0]), (end_pos[1]-start_pos[1])

# INITIALIZE BOARD
load './board.rb'
load './piece.rb'
b = Board.new(false)
b.default_board(true)
b.render


# MOVES TESTED AND WORK
b[[5,0]].perform_slide([5,0],[4,1])
b[[2,3]].perform_slide([2,3],[3,2])
b[[4,1]].perform_jump([4,1],[2,3])
b[[2,3]].perform_jump([2,3],[0,5])


# INVALID MOVES TESTED AND DON'T WORK: RETURN FALSE
b[[2,3]].perform_jump([2,3],[0,5])
b[[2,3]].perform_slide([2,3],[1,4])
b[[3,2]].perform_slide([3,2],[2,3])
b[[4,1]].perform_slide([4,1],[5,0])

# KING ME TEST
b[[5,0]].perform_slide([5,0],[4,1])
b[[2,3]].perform_slide([2,3],[3,2])
b[[4,1]].perform_jump([4,1],[2,3])
b[[0,5]]=nil
b[[2,3]].perform_jump([2,3],[0,5])
b[[0,5]].perform_slide([0,5],[1,4])

# PERFORM_MOVES! MULTI-JUMP TEST
load './board.rb'
load './piece.rb'
b = Board.new(false)
b.default_board(true)
b.render
b[[5,0]].perform_slide([5,0],[4,1])
b[[2,3]].perform_slide([2,3],[3,2])
b[[0,5]]=nil
b[[2,7]]=nil
b.render
b[[4,1]].perform_moves!([[4,1],[2,3], [2,3], [0,5]])