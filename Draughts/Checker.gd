extends Control

var board_size
var dir_black
var directions = [[1,1], [1,-1], [-1,1], [-1,-1]]
var moves = [
Vector2(1,1), Vector2(1,-1), Vector2(-1,1), Vector2(-1,-1),
Vector2(2,2), Vector2(2,-2), Vector2(-2,2), Vector2(-2,-2),
]

func set(board_size, dir_black):
	self.dir_black = dir_black
	self.board_size = board_size

func winner(state, curr_player):
	var white_has_move = false
	var black_has_move = false
	for x in range(board_size):
		for y in range(board_size):
			if state[x][y].to_lower() == "black":
				if can_move(state, Vector2(x, y)):
					black_has_move = true
			if state[x][y].to_lower() == "white":
				if can_move(state, Vector2(x, y)):
					white_has_move = true
			if black_has_move && white_has_move:
				return "none"
	if curr_player == "black" and not black_has_move:
		return "white"
	if curr_player == "white" and not white_has_move:
		return "black"
	return "none"

func is_legal(board, old, new):
	if initial_check(board, old, new) == false:
		return false
	if is_jump(old, new):
		return is_jump_correct(board, old, new)
	return not can_player_jump(board, board[old.x][old.y].to_lower())
		#if the current move is not a jump
		#while there is a possible jump
		#player has to make a jump

func initial_check(board, old, new):
	if new.x < 0 or new.x > board_size - 1 or \
	   new.y < 0 or new.y > board_size - 1:
		return false
	if board[new.x][new.y] != " ":
		return false
	if not Vector2(new.x - old.x, new.y - old.y) in moves:
		return false
	var dir = (new.y - old.y)/abs(new.y - old.y)
	return dir in allowed_dir(board[old.x][old.y])

func allowed_dir(stone):
	if stone == stone.to_upper():
		return [-1, 1]
	elif stone == "black":
		return [dir_black]
	else:
		return [-dir_black]

func is_jump_correct(board, old, new):
	var opponent = Global.opposite(board[old.x][old.y])
	if abs(old.x - new.x) != 2 or abs(old.y - new.y) != 2:
		return false
	if board[(old.x+new.x)/2][(old.y+new.y)/2].to_lower() != opponent:
		return false
	return int(new.y - old.y)/2 in allowed_dir(board[old.x][old.y])

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

func can_continue(state, old, new):
	return is_jump(old, new) and can_jump(state, new)

func is_jump(old, new):
	return abs(old.x-new.x) == 2

func can_move(state, pos):
	for m in moves:
		if is_legal(state, pos, Vector2(pos.x, pos.y) + m):
			return true
	return false