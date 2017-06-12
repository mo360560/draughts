extends Node2D

var text

func _ready():
	text = "Playing as " + Global.curr_user
	if Global.curr_user != "Guest":
		add_statistics(Global.curr_user)
	get_node("RichTextLabel").add_text(text)

func add_statistics(name):
	var stats = File.new()
	stats.open("user://" + name + "/statistics.txt", File.READ)
	var w = stats.get_line()
	var l = stats.get_line()
	var d = stats.get_line()
	text += ": " + w + " wins, " + l + " losses, " + d + " draws."