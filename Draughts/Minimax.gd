extends Control

var infinity = 1000

var board
var initial_depth
var mover
var checker
var ai_color
var opp_color

var ai_men
var ai_kings
var opp_men
var opp_kings

var zobrist_array = []
var transposition_table = {}

#Each kind of stone has it's value used to evaluate hash of board
func value_of(stone):
	if stone == "black":
		return 0
	if stone == "BLACK":
		return 1
	if stone == "white":
		return 2
	if stone == "WHITE":
		return 3

#Random value for every type of stone on every possible square
func init_zobrist_array():
	for i in range(8):
		zobrist_array.append([])
		for j in range(8):
			zobrist_array[i].append([])
			for k in range(4):
				zobrist_array[i][j].append(Vector2(randi(), randi()))

func compute_board_hash(state):
	var h = Vector2(0, 0)
	for i in range(8):
		for j in range(8):
			if state[i][j] != " ":
				var tmp = int(h[0])
				tmp ^= int(zobrist_array[i][j][value_of(state[i][j])][0])
				h[0] = tmp
				tmp = int(h[1])
				tmp ^= int(zobrist_array[i][j][value_of(state[i][j])][1])
				h[1] = tmp
	return h

func init(board, depth, ai_color):
	self.board = board
	initial_depth = depth
	self.ai_color = ai_color
	opp_color = Global.opposite(ai_color)
	mover = Global.mover
	checker = Global.checker
	init_zobrist_array()

func move():
	var m = choose_move()
	randomize()
	var r = randi()%m.size()
	board.try_move(m[r][0], m[r][1])

func choose_move():
	var state = board.board_state
	set_stones_count(state)
	var best_move = []
	var best_value = -infinity
	var curr_value
	for stone in board.currently_movable:
		for curr_move in legal_moves(state, stone.current_square.pos):
			curr_value = minimax_node_check(state, initial_depth, -infinity, infinity, ai_color, curr_move)
			if curr_value > best_value:
				best_value = curr_value
				best_move = [curr_move]
			if curr_value == best_value:
				best_move.append(curr_move)
	return best_move

#Stones count is updated at every minimax() call
#which makes heuristic() O(1)
func set_stones_count(state):
	ai_men = count_stones(state, ai_color)
	ai_kings = count_stones(state, ai_color.to_upper())
	opp_men = count_stones(state, opp_color)
	opp_kings = count_stones(state, opp_color.to_upper())

func count_stones(where, which):
	var how_many = 0
	for x in range(board.board_size):
		for y in range(board.board_size):
			if where[x][y] == which:
				how_many += 1
	return how_many

func legal_moves(state, old):
	var list = []
	for m in checker.moves:
		var new = Vector2(old.x, old.y) + m
		if checker.is_legal(state, old, new): #O(board_size^2)
			list.append([old, new])
	return list

func remove_stone(stone):
	change_stones(stone, -1)
func restore_stone(stone):
	change_stones(stone, 1)
func change_stones(stone, i):
	if stone == ai_color:
		ai_men += i
	elif stone == ai_color.to_upper():
		ai_kings += i
	elif stone == opp_color:
		opp_men += i
	elif stone == opp_color.to_upper():
		opp_kings += i

#https://en.wikipedia.org/wiki/Minimax#Pseudocode
#https://en.wikipedia.org/wiki/Alpha%E2%80%93beta_pruning#Pseudocode
func minimax(state, depth, alpha, beta, curr_player):
	if depth == 0:
		return heuristic(state)
	var best_value = best_value(curr_player)
	var curr_value
	var curr_hash
	for pos in player_stones_positions(state, curr_player):
		for curr_move in legal_moves(state, pos):
			curr_value = minimax_node_check(state, depth, alpha, beta, curr_player, curr_move)
			if curr_player == ai_color:
				best_value = max(best_value, curr_value)
				alpha = max(best_value, alpha)
			else: #minimizingPlayer
				best_value = min(best_value, curr_value)
				beta = min(beta, best_value)
			if beta <= alpha:
				return best_value
	# if no moves are possible, best_value = +/- infinity
	return best_value

var continue_move = false
var jumping_stone_pos
func player_stones_positions(state, color):
	if continue_move:
		#player has to continue jumping
		continue_move = false
		return [jumping_stone_pos]
	var pos_list = []
	for x in range(board.board_size):
		for y in range (board.board_size):
			if state[x][y].to_lower() == color:
				pos_list.append(Vector2(x, y))
	return pos_list

func minimax_node_check(state, depth, alpha, beta, curr_player, curr_move):
	var opponent = Global.opposite(curr_player)
	var old = curr_move[0]
	var new = curr_move[1]
	var curr_value
	#remembering old values
	var middle = state[(old.x+new.x)/2][(old.y+new.y)/2]
	var old_stone = state[old.x][old.y]
	#setting new values
	var new_stone = new_stone(state, old, new) #man can be promoted to king
	state[(old.x+new.x)/2][(old.y+new.y)/2] = " "
	
	state[new.x][new.y] = new_stone
	state[old.x][old.y] = " "
	if checker.is_jump(old, new):
		remove_stone(middle)
	var curr_hash = compute_board_hash(state)
	if checker.can_continue(state, old, new):
		continue_move = true
		jumping_stone_pos = new
		if not transposition_table.has(curr_hash):
			curr_value = minimax(state, depth, alpha, beta, curr_player)
			transposition_table[curr_hash] = curr_value
		else:
			curr_value = transposition_table[curr_hash]
	else:
		if not transposition_table.has(curr_hash):
			curr_value = minimax(state, depth-1, alpha, beta, opponent)
			transposition_table[curr_hash] = curr_value
		else:
			curr_value = transposition_table[curr_hash]

	#rollback:
	if checker.is_jump(old, new):
		restore_stone(middle)
	state[(old.x+new.x)/2][(old.y+new.y)/2] = middle
	state[old.x][old.y] = old_stone
	state[new.x][new.y] = " "
	return curr_value

#promotes man to king if the stone reached last line
func new_stone(state, old, new):
	var new_stone = state[old.x][old.y]
	if new.y == 0 or new.y == board.board_size - 1:
		new_stone = new_stone.to_upper()
	return new_stone

func best_value(player):
	if player == ai_color:
		return -infinity
	return infinity

func heuristic(state):
	return 3*ai_kings + ai_men - (3*opp_kings + opp_men)
