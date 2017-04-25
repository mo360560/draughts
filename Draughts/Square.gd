extends Area2D

var square_size = preload("res://blank.png").get_width()
var stone = null
var pos

func set_position(x, y):
	pos = Vector2(x, y)
	set_pos(Vector2(x*square_size, y*square_size))
	
func set_stone(stone):
	self.stone = stone

func _mouse_enter():
	get_parent().active_square = self
func _mouse_exit():
	if (get_parent().active_square == self):
		get_parent().active_square = null
