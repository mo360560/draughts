extends Sprite

var board_size = 8
var squares = []
var active_square
var square_size
var turn = "black"
var board_stones

func _ready():
	Global.mover.board = self
	Global.checker.turn = turn
	set_squares()
	set_stones()

func set_squares():
	var square = load("res://Square.tscn")
	square_size = square.instance().square_size
	for x in range(board_size): #White squares aren't really necessary
		squares.append([])
		squares[x] = []
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
			curr_stone.board = self
			add_child(curr_stone)
			curr_stone.put_on_square(squares[i%8][i/8])
			if (i in white):
				curr_stone.set_color("white")
			if (i in black):
				curr_stone.set_color("black")
			squares[i%8][i/8].set_stone(curr_stone)
	board_stones = set_board()
	
func delete_stone(x, y):
	squares[x][y].stone.queue_free()
	squares[x][y].set_stone(null)
	
func next_turn():
	board_stones = set_board()
	if turn == "white":
		turn = "black"
	else:
		turn = "white"
	Global.checker.turn = turn

func set_board():
	var board = []
	for x in range(board_size):
		board.append([])
		for y in range(board_size):
			board[x].append([])
			if squares[x][y].stone != null and squares[x][y].stone.type == "normal":
				board[x][y] = squares[x][y].stone.color
			elif squares[x][y].stone != null and squares[x][y].stone.type == "king":
				board[x][y] = squares[x][y].stone.color.to_upper()
			else:
				board[x][y] = " "
	return board

