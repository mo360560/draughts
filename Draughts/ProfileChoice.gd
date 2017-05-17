extends Button

var text

func prepare(text):
	self.text = text
	set_text(text)
	#get_node("Text").set_bbcode("[center]" + text + "[/center]")
	var avatar = load("user://" + String(text) + "/avatar.png")
	avatar.set_size_override(Vector2(60, 60))
	set_button_icon(avatar)

func _on_ProfileChoice_pressed():
	Global.curr_user = text
	get_tree().change_scene("res://Game.tscn")
