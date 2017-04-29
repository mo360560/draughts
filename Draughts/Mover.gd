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
	if new.y == 0 or new.y == board.board_size - 1:
		stone.promote()
	board.set_board_state()
	if was_jump(old, new) and checker.can_jump(board.board_state, new):
		board.continue_turn(board.squares[new.x][new.y].stone)
		#board.next_turn()
	else:
		board.next_turn()

func was_jump(old, new):
	return abs(old.x-new.x) == 2