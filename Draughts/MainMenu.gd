extends Control

func _on_Start_pressed():
	get_tree().change_scene("res://Game.tscn")

func _on_Exit_pressed():
	get_tree().quit()

func _on_Profiles_pressed():
	get_tree().change_scene("res://Profiles.tscn")
