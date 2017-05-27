extends Control

func _ready():
	if Global.winner == "draw":
		get_node("TextEdit").set_text("Draw!")
	else:
		get_node("TextEdit").set_text(Global.winner + " won!")

func _on_Again_pressed():
	get_tree().change_scene("res://Game.tscn")

func _on_Exit_pressed():
	get_tree().quit()
