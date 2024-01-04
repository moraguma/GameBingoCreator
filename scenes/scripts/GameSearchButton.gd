extends Button


var cover_id: String


@onready var game_search: GameSearch = $"../../"


func clicked():
	game_search.select_game(cover_id)
