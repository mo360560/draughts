extends Control

var board

func move(old_x, old_y, new_x, new_y):
	if new_y == 0 or new_y == board.board_size - 1:
		var king = load("res://King.tscn").instance()
		board.add_child(king)
		king.board = board
		board.squares[new_x][new_y].set_stone(king)
		king.put_on_square(board.squares[new_x][new_y])
		king.set_color(board.squares[old_x][old_y].stone.color)

		board.delete_stone(old_x, old_y)
	else:
		board.squares[old_x][old_y].stone.put_on_square(board.squares[new_x][new_y])
		board.squares[new_x][new_y].set_stone(board.squares[old_x][old_y].stone)
	board.squares[old_x][old_y].set_stone(null)
	if abs(old_x - new_x) == 2:
		board.delete_stone((old_x + new_x) / 2, (old_y + new_y) / 2)
	