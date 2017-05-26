extends Node2D

var curr_user
var winner = "none"
var checker = load("res://Checker.tscn").instance()
var mover = load("res://Mover.tscn").instance()
var minimax = load("res://Minimax.tscn").instance()

#AIvsAi testing:
var minimax2 = load("res://Minimax2.tscn").instance()
var m1_wins = 0
var m2_wins = 0
var draws = 0
var curr_game = 1
var games_total = 50
var ai_color = "white"

func opposite(color):
	if color == null:
		return "white"
	if color.to_lower() == "white":
		return "black"
	else:
		return "white"