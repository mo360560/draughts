extends Control
var turn
var board_size
var dir_black

func set(turn, board_size, dir_black):
	self.dir_black = dir_black
	self.turn = turn
	self.board_size = board_size

func winner(board):
	return "none"
	var are_there_whites = false
	var are_there_blacks = false
	for row in board:
		for el in row:
			if el.to_lower() == "white":
				are_there_whites = true
			if el.to_lower() == "black":
				are_there_blacks = true
			if are_there_whites and are_there_blacks:
				return "none"
	if are_there_whites:
		return "white"
	return "black"

func is_legal(board, old, new):
	if new.x < 0 or new.x > board_size - 1 or \
	   new.y < 0 or new.y > board_size - 1:
		return false
	if board[old.x][old.y] == " ":
		#print("aoko")
		return false
	if board[new.x][new.y] != " ":
		return false
	#if turn != board[old.x][old.y].to_lower():
	#	return false
	if is_move_correct(board, old, new):
		return true
	if is_jump_correct(board, old, new):
		return true
	else:
		#print("error")
		return false

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
	if board[(old.x+new.x)/2][(old.y+new.y)/2] != opponent:
		return false
	return int(new.y - old.y)/2 in allowed_directions(board[old.x][old.y])

func can_anyone_jump(board):
	for x in range(board.size()):
		for y in range(board.size()):
			if can_jump(board, Vector2(x, y)) and board[x][y].to_lower() == turn:
				return true
	return false

func can_jump(board, old):
	var x = old.x
	var y = old.y
	if x > 1 and y > 1:
		if self.is_jump_correct(board, old, Vector2(x - 2, y - 2)):
			return true
	elif x > 1 and y < board.size() - 2:
		if self.is_jump_correct(board, old, Vector2(x - 2, y + 2)):
			return true
	elif x < board.size() - 2 and y > 1:
		if self.is_jump_correct(board, old, Vector2(x + 2, y - 2)):
			return true
	elif x < board.size() - 2 and y < board.size() - 2:
		if self.is_jump_correct(board, old, Vector2(x + 2, y + 2)):
			return true
	return false
