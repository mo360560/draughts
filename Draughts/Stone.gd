extends Area2D

var black = preload("res://stone_black.png")
var white = preload("res://stone_white.png")
var color
var current_square
var board
var square_size = load("res://Square.tscn").instance().square_size

func set_color(c):
	color = c
	if (color == "white"):
		get_node("Sprite").set_texture(white)
	if (color == "black"):
		get_node("Sprite").set_texture(black)

func put_on_square(square):
	get_node("Sprite").set_z(0)
	if current_square != null:
		current_square.set_stone(null)
	square.set_stone(self)
	current_square = square
	set_pos(square.get_pos() + get_node("Sprite").get_texture().get_size()/2)

var is_held = false

func _process(delta):
	dragging()

func _input_event(viewport, event, shape_idx):
	if (event.type == InputEvent.MOUSE_BUTTON \
        and event.button_index == BUTTON_LEFT):
		if (event.pressed):
			is_held = true
			set_process(true)
		else:
			is_held = false

func dragging():
	if board.turn != self.color:
		return
	var target_square = get_parent().active_square
	if (is_held):
		set_global_pos(get_global_mouse_pos())
		get_node("Sprite").set_z(1)
	else:
		if legal_move(target_square):
			put_on_square(get_parent().active_square)
			board.next_turn()
		else:
			put_on_square(current_square)
		set_process(false)

func legal_move(target_square):
	if (target_square == null):
		return false
	if (target_square.stone != null):
		return false
	if self.is_jump_correct(target_square):
				board.delete_stone(Vector2((target_square.get_pos().x + current_square.get_pos().x) / 2, (target_square.get_pos().y + \
						current_square.get_pos().y) / 2))
				return true
	if abs(int(target_square.get_pos().x / square_size) - \
		int(current_square.get_pos().x / square_size)) != 1 or \
		(int(target_square.get_pos().y / square_size) - \
		int(current_square.get_pos().y / square_size) != 1 and \
		color == "white"):
			return false
	if abs(int(target_square.get_pos().x / square_size) - \
		int(current_square.get_pos().x / square_size)) != 1 or \
		(int(target_square.get_pos().y / square_size) - \
		int(current_square.get_pos().y / square_size) != -1 and \
		color == "black"):
			return false
	if board.can_anyone_jump():
		print('możesz przeskoczyć')
		return false
	return true
	
func is_jump_correct(target_square):
	return (target_square.stone == null and \
		abs(int(target_square.get_pos().x / square_size) - \
		int(current_square.get_pos().x / square_size)) == 2 and \
		board.squares[(int(target_square.get_pos().x / square_size) + int(current_square.get_pos().x / square_size)) / 2 ][(int(target_square.get_pos().y / square_size) + \
		int(current_square.get_pos().y / square_size)) / 2 ].stone != null and \
		board.squares[(int(target_square.get_pos().x / square_size) + int(current_square.get_pos().x / square_size)) / 2 ][(int(target_square.get_pos().y / square_size) + \
		int(current_square.get_pos().y / square_size)) / 2].stone.color != current_square.stone.color) and \
		((int(target_square.get_pos().y / square_size) - \
		int(current_square.get_pos().y / square_size) == 2 and color == "white") or \
		(int(target_square.get_pos().y / square_size) - \
		int(current_square.get_pos().y / square_size) == -2 and color == "black"))