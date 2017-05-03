extends Button

var name

func prepare(n):
	name = n
	set_text(name)
	var avatar = load("user://" + String(name) + "/avatar.png")
	avatar.set_size_override(Vector2(60, 60))
	set_button_icon(avatar)

func _on_ProfileChoice_pressed():
	Global.curr_user = name
	get_tree().change_scene("res://MainMenu.tscn")
