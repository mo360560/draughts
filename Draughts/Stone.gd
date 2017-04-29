extends Area2D

var man_black = preload("res://man_black.png")
var man_white = preload("res://man_white.png")
var king_black = preload("res://king_black.png")
var king_white = preload("res://king_white.png")
var current_square = null
var type

func set_type(type):
	self.type = type
	if (type == "white"):
		get_node("Sprite").set_texture(man_white)
	if (type == "black"):
		get_node("Sprite").set_texture(man_black)
	if (type == "WHITE"):
		get_node("Sprite").set_texture(king_white)
	if (type == "BLACK"):
		get_node("Sprite").set_texture(king_black)

func promote():
	set_type(type.to_upper())

func put_on_square(square):
	get_node("Sprite").set_z(0)
	if current_square != null:
		current_square.set_stone(null)
	current_square = square
	current_square.set_stone(self)
	set_pos(square.get_pos() + get_node("Sprite").get_texture().get_size()/2)

var is_held = false

func _process(delta):
	dragging()

func _input_event(viewport, event, shape_idx):
	if (event.type == InputEvent.MOUSE_BUTTON \
        and event.button_index == BUTTON_LEFT):
		if (event.pressed):
			if get_parent().turn == type.to_lower():
				is_held = true
				set_process(true)
		else:
			is_held = false

func dragging():
	var target_square = get_parent().active_square
	if (is_held):
		set_global_pos(get_global_mouse_pos())
		get_node("Sprite").set_z(1)
	else:
		var success = false
		if target_square != null:
			var old = current_square.pos
			var new = target_square.pos
			success = get_parent().try_move(old, new)
		if not success:
			put_on_square(current_square)
		set_process(false)