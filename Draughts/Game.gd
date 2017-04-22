extends Node2D

func _ready():
	get_node("RichTextLabel").add_text("Playing as " + Global.curr_user)

