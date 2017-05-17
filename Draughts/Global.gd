extends Node2D

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