extends Node2D

var curr_user = "Guest"
var winner = "none"
var checker = load("res://Checker.tscn").instance()
var mover = load("res://Mover.tscn").instance()
var minimax = load("res://Minimax.tscn").instance()

#AIvsAi testing:
var m1_color = "black"
var m2_color = "white"
var minimax2 = load("res://Minimax2.tscn").instance()
var minimax3 = load("res://Minimax3.tscn").instance()
var m1_wins = 0
var m2_wins = 0
var draws = 0
var curr_game = 1
var games_total = 100


func opposite(color):
	#if color == null:
	#	return "white"
	if color.to_lower() == "white":
		return "black"
	else:
		return "white"