extends Node2D

func _ready():
	if (Global.curr_user == null):
		get_tree().change_scene("res://Profiles.tscn")
	else:
		get_node("RichTextLabel").add_text("Playing as " + Global.curr_user)

