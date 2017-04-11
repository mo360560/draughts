extends Area2D

var square_size = preload("res://blank.png").get_width()
var status = "free"

func set_position(x, y):
	set_pos(Vector2(x*square_size, y*square_size))

func _mouse_enter():
	get_parent().active_square = self
func _mouse_exit():
	if (get_parent().active_square == self):
		get_parent().active_square = null
