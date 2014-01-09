
UNICODES = {
  :r_king => "\u2689",
  :r_piece => "\u2688",
  :w_king => "\u2687",
  :w_piece => "\u2686"
}

start_pos = [0,0]
end_pos = [1,1]
cur_move_diff = (end_pos[0]-start_pos[0]), (end_pos[1]-start_pos[1])

load './board.rb'
load './piece.rb'
b = Board.new(false)
p = Piece.new(b, :red, [0,1])