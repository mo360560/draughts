extends Area2D

var black = preload("res://stone_black.png")
var white = preload("res://stone_white.png")
var color
var current_square = null
var board
var type = "normal"

func set_color(c):
	color = c
	if (color == "white"):
		get_node("Sprite").set_texture(white)
	if (color == "black"):
		get_node("Sprite").set_texture(black)

func put_on_square(square):
	get_node("Sprite").set_z(0)
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
		if target_square != null and \
		Global.checker.is_legal(board.board_stones, current_square.pos.x, current_square.pos.y, target_square.pos.x, target_square.pos.y):
			Global.mover.move(current_square.pos.x, current_square.pos.y, target_square.pos.x, target_square.pos.y)
			put_on_square(get_parent().active_square)
			board.next_turn()
		else:
			put_on_square(current_square)
		set_process(false)