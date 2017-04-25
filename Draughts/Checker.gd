extends Control
var turn

func winner(board):
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
	

func is_legal(board, old_x, old_y, new_x, new_y):
	if (board[new_x][new_y] != " "):
		return false
	if self.is_jump_correct(board, old_x, old_y, new_x, new_y):
		return true
	if board[old_x][old_y] == "white" or board[old_x][old_y] == "black":
		if (abs(old_x - new_x) != 1 or \
			new_y - old_y != 1) and \
			board[old_x][old_y] == "white":
				return false
		if (abs(old_x - new_x) != 1 or \
			new_y - old_y != -1) and \
			board[old_x][old_y] == "black":
				return false
	elif board[old_x][old_y] == "WHITE" or board[old_x][old_y] == "BLACK":
		if abs(old_x - new_x) != 1 or \
			abs(old_y - new_y) != 1:
				return false
	if Global.checker.can_anyone_jump(board):
		return false
	return true
	
func is_jump_correct(board, old_x, old_y, new_x, new_y):
	if board[(old_x + new_x) / 2][(old_y + new_y) / 2] == " ":
		return false
	if board[old_x][old_y] == "white" or board[old_x][old_y] == "black":
		return board[new_x][new_y] == " " and \
			abs(old_x - new_x)  == 2 and \
			board[(old_x + new_x) / 2][(old_y + new_y) / 2].to_lower() != board[old_x][old_y].to_lower() and \
			(new_y - old_y == 2 and board[old_x][old_y] == "white" or \
			(new_y - old_y == -2 and board[old_x][old_y] == "black"))
	elif board[old_x][old_y] == "WHITE" or board[old_x][old_y] == "BLACK":
		return board[new_x][new_y] == " " and \
			abs(old_x - new_x)  == 2 and \
			board[(old_x + new_x) / 2][(old_y + new_y) / 2].to_lower() != board[old_x][old_y].to_lower() and \
			abs(new_y - old_y) == 2
	return false

func can_anyone_jump(board):
	for x in range(board.size()):
		for y in range(board.size()):
			if can_jump(board, x, y) and board[x][y].to_lower() == turn:
				return true
	return false

func can_jump(board, x, y):
	var current_stone = board[x][y]
	if current_stone != " " :
		if x > 1 and y > 1:
			if self.is_jump_correct(board, x, y, x - 2, y - 2):
				return true
		elif x > 1 and y < board.size() - 2:
			if self.is_jump_correct(board, x, y, x - 2, y + 2):
				return true
		elif x < board.size() - 2 and y > 1:
			if self.is_jump_correct(board, x, y, x + 2, y - 2):
				return true
		elif x < board.size() - 2 and y < board.size() - 2:
			if self.is_jump_correct(board, x, y, x + 2, y + 2):
				return true
	return false
