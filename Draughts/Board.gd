extends Sprite

var board_size = 8
var squares = []
var active_square
var square_size
var turn = "white"

func _ready():
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
	
func delete_stone(pos):
	squares[int(pos.x / square_size)][int(pos.y / square_size)].stone.queue_free()
	squares[int(pos.x / square_size)][int(pos.y / square_size)].set_stone(null)
	
func next_turn():
	for i in range(board_size):
		if squares[i][0].stone != null and squares[i][0].stone.color == "black":
			squares[i][0].stone.queue_free()
			var king_black = load("res://King.tscn").instance()
			king_black.board = self
			add_child(king_black)
			king_black.put_on_square(squares[i][0])
			king_black.set_color("black")
			squares[i%8][i/8].set_stone(king_black)
		if squares[i][7].stone != null and squares[i][7].stone.color == "white":
			squares[i][7].stone.queue_free()
			var king_white = load("res://King.tscn").instance()
			king_white.board = self
			add_child(king_white)
			king_white.put_on_square(squares[i][7])
			king_white.set_color("white")
			squares[i%8][i/8].set_stone(king_white)
			
	if turn == "white":
		turn = "black"
	else:
		turn = "white"
func can_anyone_jump():
	for x in range(board_size):
		for y in range(board_size):
			var current_stone = squares[x][y].stone
			if current_stone != null and current_stone.color == turn:
				if x > 1 and y > 1:
					if current_stone.is_jump_correct(squares[x - 2][y - 2]):
						return true
				elif x > 1 and y < board_size - 2:
					if current_stone.is_jump_correct(squares[x - 2][y + 2]):
						return true
				elif x < board_size - 2 and y > 1:
					if current_stone.is_jump_correct(squares[x + 2][y - 2]):
						return true
				elif x < board_size - 2 and y < board_size - 2:
					if current_stone.is_jump_correct(squares[x + 2][y + 2]):
						return true
	return false