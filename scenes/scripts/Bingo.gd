extends Node2D
class_name Bingo


@onready var covers: Array[BingoCover] = [
	$VBoxContainer/HBoxContainer/Control, $VBoxContainer/HBoxContainer/Control2, $VBoxContainer/HBoxContainer/Control3, $VBoxContainer/HBoxContainer/Control4, $VBoxContainer/HBoxContainer/Control5, 
	$VBoxContainer/HBoxContainer2/Control, $VBoxContainer/HBoxContainer2/Control2, $VBoxContainer/HBoxContainer2/Control3, $VBoxContainer/HBoxContainer2/Control4, $VBoxContainer/HBoxContainer2/Control5, 
	$VBoxContainer/HBoxContainer3/Control, $VBoxContainer/HBoxContainer3/Control2, $VBoxContainer/HBoxContainer3/Control4, $VBoxContainer/HBoxContainer3/Control5, 
	$VBoxContainer/HBoxContainer4/Control, $VBoxContainer/HBoxContainer4/Control2, $VBoxContainer/HBoxContainer4/Control3, $VBoxContainer/HBoxContainer4/Control4, $VBoxContainer/HBoxContainer4/Control5, 
	$VBoxContainer/HBoxContainer5/Control, $VBoxContainer/HBoxContainer5/Control2, $VBoxContainer/HBoxContainer5/Control3, $VBoxContainer/HBoxContainer5/Control4, $VBoxContainer/HBoxContainer5/Control5, 
]
@onready var back_button: Button = $Back
@onready var save_button: Button = $Save
@onready var console: Console = $"../Console"


func fisher_yates_shuffle(l):
	var n = len(l)
	
	for i in range(n - 1):
		var j = randi() % (n - i) + i
		var aux = l[j]
		l[j] = l[i]
		l[i] = aux


func create(games: Array[Texture]):
	fisher_yates_shuffle(covers)
	for i in range(len(covers)):
		if i < len(games):
			covers[i].set_tex(games[i])
		else:
			covers[i].make_free_space()
	
	show()


func back():
	hide()


func save():
	back_button.hide()
	save_button.hide()
	console.reset()
	
	await get_tree().process_frame
	await get_tree().process_frame
	
	var img = get_viewport().get_texture().get_image()
	var path = "res://bingos/%s.png" % [Time.get_datetime_string_from_system().replace(":", "-")]
	var error = img.save_png(path)
	
	console.write("Saved to %s" % [path])
	
	back_button.show()
	save_button.show()

