extends Area2D

var black = preload("res://stone_black.png")
var white = preload("res://stone_white.png")
var color
var current_square

func set_color(c):
	color = c
	if (color == "white"):
		get_node("Sprite").set_texture(white)
	if (color == "black"):
		get_node("Sprite").set_texture(black)

func put_on_square(square):
	get_node("Sprite").set_z(0)
	if (current_square != null):
		current_square.status = "free"
	square.status = color
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
	if (is_held):
		set_global_pos(get_global_mouse_pos())
		get_node("Sprite").set_z(1)
	else:
		if (legal_move()):
			put_on_square(get_parent().active_square)
		else:
			put_on_square(current_square)
		set_process(false)

func legal_move():
	var target_square = get_parent().active_square
	if (target_square == null):
		return false
	if (target_square.status != "free"):
		return false
	return true