extends Node2D

var profiles = File.new()
var choice = load("res://ProfileChoice.tscn")

var choices = []
var buttons = []

func _ready():
	profiles.open("user://profiles.txt", File.READ)
	var name = profiles.get_line()
	while name != "":
		if not name in choices:
			var new_choice = choice.instance()
			new_choice.prepare(name)
			choices.append(name)
			get_node("ScrollContainer/VBoxContainer").add_child(new_choice)
		name = profiles.get_line()
	profiles.close()

var textbox_open = false
func _on_Button_pressed():
	if not textbox_open:
		get_node("AddNew").add_child(load("res://NewName.tscn").instance())
		get_node("AddNew").set_text("Accept name")
	else:
		get_node("AddNew").set_text("Add profile")
		var textbox = get_node("AddNew").get_child(0)
		add_new_user(textbox.get_line(0))
		textbox.queue_free()
	textbox_open = not textbox_open

func add_new_user(name):
	if not name in choices:
		add_to_list(name)
		create_directory(name)
		create_default_avatar(name)
		create_statistics(name)
		_ready()

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

var empty_statistics = "0\r\n0\r\n0\r\n"
func create_statistics(name):
	var statistics = File.new() 
	statistics.open("user://" + name + "/statistics.txt", File.WRITE)
	statistics.store_string(empty_statistics)
	statistics.close()

func open_to_write():
	profiles.open("user://profiles.txt", File.READ_WRITE)
	if not profiles.is_open():
		profiles.open("user://profiles.txt", File.WRITE)
	profiles.seek_end()