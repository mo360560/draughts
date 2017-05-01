extends Node2D

var a = false
var curr_user
var winner = "none"
var checker = load("res://Checker.tscn").instance()
var mover = load("res://Mover.tscn").instance()
var minimax = load("res://Minimax.tscn").instance()

func opposite(color):
	if color == null:
		return "white"
	if color.to_lower() == "white":
		return "black"
	else:
		return "white"

func show_state(current_state):
	print("state:")
	for x in range(8):
		var line = []
		for y in range(8):
			line.append(current_state[y][x][0])
		print(line)