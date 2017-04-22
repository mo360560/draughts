extends Node2D

var profiles = File.new()

func _ready():
	load_profiles()
	
var i = 0
var choices = []

func load_profiles():
	var choice = load("res://ProfileChoice.tscn")
	profiles.open("user://profiles.txt", File.READ)
	i = 0
	var name = profiles.get_line()
	while name != "": #not profiles.eof_reached()
		if not name in choices:
			var new_choice = choice.instance()
			new_choice.prepare(name)
			get_node("ScrollContainer/VBoxContainer").add_child(new_choice)
			choices.append(name)
		name = profiles.get_line()
		i += 1
	get_node("ScrollContainer").set_size(Vector2(600, 400))
	get_node("ScrollContainer/VBoxContainer").set_size(Vector2(600, 400))
	#get_node("List").get_button_list(choices)

func _on_Button_pressed():
	add_new_user("User" + String(i))

func add_new_user(name):
	if not name in choices:
		add_to_list(name)
		create_directory(name)
		create_default_avatar(name)
		load_profiles()

func add_to_list(name):
		open_to_write()
		profiles.store_string(name + "\r\n")
		profiles.close()

func create_directory(name):
		var dir = Directory.new()
		dir.open("user://")
		dir.make_dir(name)

func create_default_avatar(name):
		var avatar = Image()
		avatar.load("res://avatar.png")
		avatar.save_png("user://" + name + "/avatar.png")

func open_to_write():
	profiles.open("user://profiles.txt", File.READ_WRITE)
	if not profiles.is_open():
		profiles.open("user://profiles.txt", File.WRITE)
	profiles.seek_end()