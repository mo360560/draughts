extends Control

var board

func set(board):
	self.board = board

func move(old, new):
	var stone = board.squares[old.x][old.y].stone
	stone.put_on_square(board.squares[new.x][new.y])
	if abs(old.x - new.x) == 2:
		board.delete_stone((old.x + new.x) / 2, (old.y + new.y) / 2)
	if new.y == 0 or new.y == board.board_size - 1:
		stone.promote()
	board.set_board_state()
	board.next_turn()