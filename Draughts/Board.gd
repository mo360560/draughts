extends Sprite

var board_size = 8
var squares = []
var active_square

func _ready():
	set_squares()
	set_stones()

func set_squares():
	var square = load("res://Square.tscn")
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
			add_child(curr_stone)
			curr_stone.put_on_square(squares[i%8][i/8])
			if (i in white):
				curr_stone.set_color("white")
			if (i in black):
				curr_stone.set_color("black")