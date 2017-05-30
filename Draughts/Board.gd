extends Sprite

var board_size = 8
var squares = []
var board_state = []
var black_stones = []
var white_stones = []
var currently_movable = []
var active_square
var turn = "black"
var ai_color = "white" #or "black" or "none"
var checker = Global.checker
var mover = Global.mover
var minimax = Global.minimax3

#AIvsAI testing:
var AIvsAI = true
var moves = 0
var minimax2 = Global.minimax2
var max_moves = 180

func _ready():
	set_squares()
	set_stones()
	set_board_state()
	set_movable()
	mover.set(self, checker)
	checker.set(board_size, -1)
	if (AIvsAI):
		minimax.init(self, 2, Global.m1_color)
		minimax2.init(self, 2, Global.m2_color)
	else:
		minimax.init(self, 4, ai_color)
	ask_for_next_move()

func set_squares():
	var square = load("res://Square.tscn")
	for x in range(board_size):
		squares.append([])
		for y in range(board_size):
			squares[x].append([])
			squares[x][y] = square.instance()
			add_child(squares[x][y])
			squares[x][y].set_position(x, y)

func set_stones():
	var stone = load("res://Stone.tscn")
	var curr_stone
	var white = [1, 3, 5, 7, 8, 10, 12, 14, 17, 19, 21, 23]
	var black = [40, 42, 44, 46, 49, 51, 53, 55, 56, 58, 60, 62]
	#var white = [19, 35, 37]
	#var black = [44, 46]
	for i in range(board_size * board_size):
		if (i in white or i in black):
			curr_stone = stone.instance()
			add_child(curr_stone)
			curr_stone.put_on_square(squares[i%8][i/8])
			if (i in black):
				curr_stone.set_type("black")
				black_stones.append(curr_stone)
			if (i in white):
				curr_stone.set_type("white")
				white_stones.append(curr_stone)
			squares[i%8][i/8].set_stone(curr_stone)

func set_movable():
	if turn == "black":
		currently_movable = black_stones
	else:
		currently_movable = white_stones

func set_board_state():
	for x in range(board_size):
		board_state.append([])
		for y in range(board_size):
			board_state[x].append([])
			if squares[x][y].stone == null:
				board_state[x][y] = " "
			else:
				board_state[x][y] = squares[x][y].stone.type

func delete_stone(x, y):
	black_stones.erase(squares[x][y].stone)
	white_stones.erase(squares[x][y].stone)
	squares[x][y].stone.queue_free()
	squares[x][y].set_stone(null)

func try_move(old, new):
	if checker.is_legal(board_state, old, new):
		var what_next = mover.move(old, new)
		if what_next == "continue":
			continue_turn(new)
		else:
			next_turn()
		if check_winner() == "none":
			ask_for_next_move()
		return true
	else:
		return false

func ask_for_next_move():
	if AIvsAI:
		if turn == Global.m1_color:
			minimax.move()
		elif turn == Global.m2_color:
			minimax2.move()
		else:
			print("error")
	else:
		if turn == ai_color:
			minimax.move()

func next_turn():
	moves += 1
	turn = Global.opposite(turn)
	set_movable()

func continue_turn(pos):
	var stone_that_jumped = squares[pos.x][pos.y].stone
	currently_movable = [stone_that_jumped]

func check_winner():
	Global.winner = checker.winner(board_state, turn)
	if moves > max_moves:
		Global.winner = "draw"
	if Global.winner != "none":
		if AIvsAI:
			if Global.winner == "draw":
				Global.draws += 1
			elif Global.winner == Global.m1_color:
				Global.m1_wins += 1
			elif Global.winner == Global.m2_color:
				Global.m2_wins += 1
			print("Results after ", Global.curr_game, " games:")
			print("Minimax1: ", Global.m1_wins)
			print("Minimax2: ", Global.m2_wins)
			print("Draws: ", Global.draws)
			
			Global.m1_color = Global.opposite(Global.m1_color)
			Global.m2_color = Global.opposite(Global.m2_color)
			Global.curr_game += 1
			get_parent().queue_free()
			if (Global.curr_game < Global.games_total):
				get_tree().change_scene("res://Game.tscn")
		else:
			get_tree().change_scene("res://WinScreen.tscn")
	return Global.winner

