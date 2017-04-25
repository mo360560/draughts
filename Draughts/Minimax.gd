extends Control

var infinity = 1000
var board_size
var board = [] #men: "white", "black"; kings: "WHITE", "BLACK"
var ai_stones
var checker #sprawdzacz (poprawności ruchów), udostępnia funkcje:
	#is_legal(board, old_x, old_y, new_x, new_y) - sprawdza czy ruch jest legalny
	#can_jump(board, x, y) - sprawdza, czy z danego pola jest dostępne bicie
	#winner(board) - sprawdza, czy dana pozycja jest końcowa
	#                i zwraca zwycięzcę ("white"/"black"/"none")
var mover #wykonywacz ruchów, udostępnia funkcje:
	#move(old_x, old_y, new_x, new_y)
var initial_depth

func init(size, ai_color, c, m, i, squares):
	board_size = size
	ai_stones = ai_color
	checker = c
	mover = m
	initial_depth = i
	set_board(squares)

func set_board(squares):
	for x in range(board_size):
		board.append([])
		for y in range(board_size):
			board[x].append([])
			if squares[x][y].stone != null:
				board[x][y] = squares[x][y].stone.color
			else:
				board[x][y] = " "

func move():
	var m = choose_move()
	mover.move(m[0], m[1], m[2], m[3])

func choose_move():
	var new_board = Array(board) #kopiowanie
	var best_move
	var best_value = -infinity
	
	var stones_list = list_stones(ai_stones)
	for coord in stones_list:
		for i in range(-1, 1):
			for j in range(-1, 1):
				var x = coord.x
				var y = coord.y
				#bez bicia
				if checker.is_legal(new_board, x, y, x+i, y+j):
					new_board[x][y] = " "
					new_board[x+i][y+i] = ai_stones
					var v = minimax(new_board, initial_depth - 1, opponent(ai_stones))
					if v > best_value:
						best_move = [x, y, x+i, y+j]
						best_value = v
					new_board[x][y] = ai_stones
					new_board[x+i][y+i] = " "
				#bicie
				if checker.is_legal(new_board, x, y, x+i*2, y+j*2):
					var dummy = new_board[x-1][y-1]
					new_board[x][y] = " "
					new_board[x-1][y-1] = " "
					new_board[x-i*2][y-j*2] = ai_stones
					var v
					if checker.can_jump(new_board, x-i*2, y-j*2):
						v = minimax(new_board, initial_depth, ai_stones)
					else:
						v = minimax(new_board, initial_depth - 1, opponent(ai_stones))
					if v > best_value:
						best_move = [x, y, x+i, y+j]
						best_value = v
					new_board[x][y] = ai_stones
					new_board[x-1][y-1] = dummy
					new_board[x-i*2][y-j*2] = " "
	return best_move

func list_stones(color):
	var list = []
	for x in range(board_size):
		for y in range(board_size):
			if board[x][y] == color:
				list.append(Vector2(x, y))
	return list

func minimax(current_board, depth, current_player):
	if depth == 0:
		return heuristic(current_board, current_player)
	elif checker.winner(current_board) != "none":
		return final_value(current_board, current_player)
	
	if current_player == ai_stones:
		return check_moves(current_board, depth, opponent(ai_stones))
	else: #opponent's turn (minimizing player)
		return check_moves(current_board, depth, ai_stones)

func check_moves(current_board, depth, current_player):
	var new_board = Array(current_board) #kopiowanie
	
	var best_value
	if current_player == ai_stones:
		best_value = -infinity
	else:
		best_value = infinity
	
	var stones_list = list_stones(current_player)
	for coord in stones_list:
		for i in range(-1, 1):
			for j in range(-1, 1):
				#bez bicia
				if checker.is_legal(new_board, x, y, x+i, y+j):
					new_board[x][y] = " "
					new_board[x+i][y+i] = current_player
					var v = minimax(new_board, depth - 1, opponent(current_player))
					if current_player == ai_stones:
						best_value = max(best_value, v)
					else:
						best_value = min(best_value, v)
					new_board[x][y] = current_player
					new_board[x+i][y+i] = " "
				#bicie
				if checker.is_legal(new_board, x, y, x+i*2, y+j*2):
					var dummy = new_board[x-1][y-1]
					new_board[x][y] = " "
					new_board[x-1][y-1] = " "
					new_board[x-i*2][y-j*2] = current_player
					var v
					if checker.can_jump(new_board, x-i*2, y-j*2):
						v = minimax(new_board, depth, current_player)
					else:
						v = minimax(new_board, depth - 1, opponent(current_player))
					if current_player == ai_stones:
						best_value = max(best_value, v)
					else:
						best_value = min(best_value, v)
					new_board[x][y] = current_player
					new_board[x-1][y-1] = dummy
					new_board[x-i*2][y-j*2] = " "
	return best_value

func final_value(current_board, current_player):
	if current_player == checker.winner(current_board):
		return infinity
	else:
		return -infinity

func heuristic(current_board, current_player):
	var curr = count_stones(current_player)
	var opp = count_stones(opponent(current_player))
	return curr - opp

func count_stones(where, which):
	var how_many = 0
	for x in range(board_size):
		for y in range(board_size):
			if where[x][y].to_lower() == which:
				how_many += 1
	return how_many

func opponent(stones_color):
	if stones_color == "white":
		return "black"
	else:
		return "white"