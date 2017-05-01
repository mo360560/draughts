extends Control

var infinity = 1000
var moves = [
[1,1], [1,-1], [-1,1], [-1,-1],
[2,2], [2,-2], [-2,2], [-2,-2],
]

var board
var initial_depth
var mover
var checker
var ai_color
var ai_stones
var opponent_stones

func init(board, depth, ai_color):
	self.board = board
	initial_depth = depth
	self.ai_color = ai_color
	if ai_color == "black":
		ai_stones = board.black_stones
		opponent_stones = board.white_stones
	else:
		ai_stones = board.white_stones
		opponent_stones = board.black_stones
	mover = Global.mover
	checker = Global.checker

func move():
	print("NEW MOVE")
	best_heuristic = -1001
	var m = choose_move()
	mover.move(m[0], m[1])

func choose_move():
	var opponent = Global.opposite(ai_color)
	var new_state = CopyState(board.board_state)
	var best_move
	var best_value = -infinity
	for stone in board.currently_movable:
		for curr_move in legal_moves(new_state, stone.current_square.pos):
			var old = curr_move[0]
			var new = curr_move[1]
			var dummy = new_state[(old.x+new.x)/2][(old.y+new.y)/2]
			var old_stone = new_state[old.x][old.y]
			var new_stone = new_stone(new_state, old, new)
			new_state[(old.x+new.x)/2][(old.y+new.y)/2] == " "
			new_state[new.x][new.y] = new_stone
			new_state[old.x][old.y] = " "
			var curr_value = minimax(new_state, initial_depth, -infinity, infinity, opponent)
			#rollback:
			new_state[(old.x+new.x)/2][(old.y+new.y)/2] = dummy
			new_state[old.x][old.y] = old_stone
			new_state[new.x][new.y] = " "
			if curr_value >= best_value:
				best_value = curr_value
				best_move = curr_move
	return best_move

func CopyState(state):
	var new_state = []
	for i in range(board.board_size):
		new_state.append([])
		for j in range(board.board_size):
			new_state[i].append([])
			new_state[i][j] = state[i][j]
	return new_state

func legal_moves(state, old):
	var list = []
	for m in moves:
		var new = Vector2(old.x+m[0], old.y+m[1])
		if checker.is_legal(state, old, new):
			list.append([old, new])
	return list

func new_stone(new_state, old, new):
	var new_stone = new_state[old.x][old.y]
	if new.y == 0 or new.y == board.board_size - 1:
		new_stone = new_stone.to_upper()
	return new_stone

func player_stones_positions(state, color):
	var pos_list = []
	for x in range(board.board_size):
		for y in range (board.board_size):
			if state[x][y].to_lower() == color:
				pos_list.append(Vector2(x, y))
	return pos_list

func minimax(current_state, depth, alpha, beta, current_player):
	if depth == 0:
		return heuristic(current_state, current_player)
	elif checker.winner(current_state) != "none":
		return final_value(current_state, current_player)
	var new_state = CopyState(current_state)
	var best_value
	var opponent = Global.opposite(ai_color)
	if current_player == ai_color:
		best_value = -infinity
		for pos in player_stones_positions(new_state, ai_color):
			for curr_move in legal_moves(new_state, pos):
				var old = curr_move[0]
				var new = curr_move[1]
				var dummy = new_state[(old.x+new.x)/2][(old.y+new.y)/2]
				var old_stone = new_state[old.x][old.y]
				var new_stone = new_stone(new_state, old, new)
				new_state[(old.x+new.x)/2][(old.y+new.y)/2] = " "
				new_state[new.x][new.y] = new_stone
				new_state[old.x][old.y] = " "
				var curr_value = minimax(new_state, depth-1, alpha, beta, opponent)
				#rollback:
				new_state[(old.x+new.x)/2][(old.y+new.y)/2] = dummy
				new_state[old.x][old.y] = old_stone
				new_state[new.x][new.y] = " "
				best_value = max(best_value, curr_value)
				alpha = max(best_value, alpha)
				if beta <= alpha:
					return best_value
	else: #minimizingPlayer
		best_value = infinity
		for pos in player_stones_positions(new_state, opponent):
			for curr_move in legal_moves(new_state, pos):
				var old = curr_move[0]
				var new = curr_move[1]
				var dummy = new_state[(old.x+new.x)/2][(old.y+new.y)/2]
				var old_stone = new_state[old.x][old.y]
				var new_stone = new_stone(new_state, old, new)
				new_state[(old.x+new.x)/2][(old.y+new.y)/2] = " "
				new_state[new.x][new.y] = new_stone
				new_state[old.x][old.y] = " "
				var curr_value = minimax(new_state, depth-1, alpha, beta, ai_color)
				#rollback:
				new_state[(old.x+new.x)/2][(old.y+new.y)/2] = dummy
				new_state[old.x][old.y] = old_stone
				new_state[new.x][new.y] = " "
				best_value = min(best_value, curr_value)
				beta = min(beta, best_value)
				if beta <= alpha:
					return best_value
	return best_value

func final_value(current_state, current_player):
	if current_player == checker.winner(current_state):
		return infinity
	else:
		return -infinity

var best_heuristic = -1001

func heuristic(current_state, current_player):	
	var curr_men = count_stones(current_state, current_player)
	var curr_kings = count_stones(current_state, current_player.to_upper())
	var opponent = Global.opposite(current_player)
	var opp_men = count_stones(current_state, opponent)
	var opp_kings = count_stones(current_state, opponent.to_upper())
	var h = 5*curr_kings + curr_men - (5*opp_kings + opp_men)
	if h > best_heuristic:
		best_heuristic = h
		show_state(current_state)
		print("heuristic:", h)
	return 5*curr_kings + curr_men - (5*opp_kings + opp_men)

func show_state(current_state):
	print("state:")
	for x in range(8):
		var line = []
		for y in range(8):
			line.append(current_state[y][x][0])
		print(line)

func count_stones(where, which):
	var how_many = 0
	for x in range(board.board_size):
		for y in range(board.board_size):
			if where[x][y] == which:
				how_many += 1
	return how_many