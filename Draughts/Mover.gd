extends Control

var board
var checker

func set(board, checker):
	self.board = board
	self.checker = checker

func move(old, new):
	var stone = board.squares[old.x][old.y].stone
	stone.put_on_square(board.squares[new.x][new.y])
	if abs(old.x - new.x) == 2:
		board.delete_stone((old.x + new.x) / 2, (old.y + new.y) / 2)
	board.set_board_state()
	var what_next = "next"
	if board.checker.can_continue(board.board_state, old, new):
		what_next = "continue"
	if new.y == 0 or new.y == board.board_size - 1:
		stone.promote()
	return what_next