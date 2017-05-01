extends Sprite

var board_size = 8
var squares = []
var board_state = []
var black_stones = []
var white_stones = []
var currently_movable = []
var active_square
var turn = "black"
var ai_color = "white"

func _ready():
	set_squares()
	set_stones()
	set_board_state()
	set_movable()
	Global.mover.set(self, Global.checker)
	Global.checker.set(board_size, -1)
	Global.minimax.init(self, 5, ai_color)
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
	if Global.checker.is_legal(board_state, old, new):
		var what_next = Global.mover.move(old, new)
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
	if turn == ai_color:
		Global.minimax.move()

func next_turn():
	turn = Global.opposite(turn)
	set_movable()

func continue_turn(pos):
	var stone_that_jumped = squares[pos.x][pos.y].stone
	currently_movable = [stone_that_jumped]

func check_winner():
	Global.winner = Global.checker.winner(board_state)
	if Global.winner != "none":
		get_tree().change_scene("res://WinScreen.tscn")
	return Global.winner