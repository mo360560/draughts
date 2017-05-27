extends Node2D

func _ready():
	if (Global.curr_user == null):
		get_tree().change_scene("res://Profiles.tscn")
	else:
		var text = "Playing as " + Global.curr_user
		get_node("RichTextLabel").add_text(text)

