extends Control

var directions = [[1,1], [1,-1], [-1,1], [-1,-1]]
var board_size
var dir_black

func set(board_size, dir_black):
	self.dir_black = dir_black
	self.board_size = board_size

func winner(board):
	var are_there_whites = false
	var are_there_blacks = false
	for x in range(board_size):
		for y in range(board_size):
			if board[x][y].to_lower() == "white":
				are_there_whites = true
			if board[x][y].to_lower() == "black":
				are_there_blacks = true
			if are_there_whites and are_there_blacks:
				return "none"
	if are_there_whites:
		return "white"
	return "black"

func is_legal(board, old, new):
	if initial_check(board, old, new) == false:
		return false
	if is_jump_correct(board, old, new):
		return true
	if can_player_jump(board, board[old.x][old.y].to_lower()):
		#the current move is not a jump while there is a possible jump
		return false
	return is_move_correct(board, old, new)

func initial_check(board, old, new):
	if new.x < 0 or new.x > board_size - 1 or \
	   new.y < 0 or new.y > board_size - 1:
		return false
	if abs(old.x - new.x) != abs(old.y - new.y):
		return false
	if board[old.x][old.y] == " ":
		return false
	if board[new.x][new.y] != " ":
		return false
	return true

func allowed_directions(stone):
	if stone == stone.to_upper():
		return [-1, 1]
	elif stone == "black":
		return [dir_black]
	else:
		return [-dir_black]

func is_move_correct(board, old, new):
	if abs(old.x - new.x) != 1 or abs(old.y - new.y) != 1:
		return false
	return int(new.y - old.y) in allowed_directions(board[old.x][old.y])

func is_jump_correct(board, old, new):
	var opponent = Global.opposite(board[old.x][old.y])
	if abs(old.x - new.x) != 2 or abs(old.y - new.y) != 2:
		return false
	if board[(old.x+new.x)/2][(old.y+new.y)/2].to_lower() != opponent:
		return false
	return int(new.y - old.y)/2 in allowed_directions(board[old.x][old.y])

func can_player_jump(board, color):
	for x in range(board_size):
		for y in range(board_size):
			if board[x][y].to_lower() == color:
				if can_jump(board, Vector2(x, y)):
					return true
	return false

func can_jump(board, old):
	for v in directions:
		var new = Vector2(old.x + v[0]*2, old.y + v[1]*2)
		if initial_check(board, old, new):
			if is_jump_correct(board, old, new):
				return true
	return false
