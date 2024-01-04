extends VBoxContainer
class_name GameDisplay


const MAX_GAMES = 24
const COVER_SCENE = preload("res://scenes/GameCoverButton.tscn")


var total = 0


@onready var game_container: GridContainer = $Padding/GridContainer
@onready var game_counter: RichTextLabel = $Info/Count
@onready var bingo: Bingo = $"../../Bingo"


func add_game(texture: Texture):
	if total < MAX_GAMES:
		total += 1
		game_counter.text = " %s/%s" % [total, MAX_GAMES]
		
		var new_cover = COVER_SCENE.instantiate()
		new_cover.texture = texture
		game_container.add_child(new_cover)


func delete_game(game: CoverButton):
	game.queue_free()
	
	total -= 1
	game_counter.text = " %s/%s" % [total, MAX_GAMES]


func create():
	var textures: Array[Texture] = []
	
	for game in game_container.get_children():
		textures.append(game.texture)
	
	bingo.create(textures)
