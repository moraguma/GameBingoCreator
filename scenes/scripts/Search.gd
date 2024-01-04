extends VBoxContainer
class_name GameSearch

@onready var main: GameSelector = $"../../"
@onready var display: GameDisplay = $"../Games"

@onready var search_bar: TextEdit = $SearchBar/SearchBar
@onready var search_button: Button = $SearchBar/SearchButton
@onready var no_matches: Label = $Results/NoMatches
@onready var search_results: Array[Button] = [$Results/Game1, $Results/Game2, $Results/Game3, $Results/Game4, $Results/Game5, $Results/Game6, $Results/Game7, $Results/Game8, $Results/Game9, $Results/Game10, $Results/Game11, $Results/Game12]

func search():
	if search_bar.text != "":
		var old_text = search_bar.text
		search_bar.clear()
		var games = await main.search_for_titles(old_text)
		
		if len(games) == 0:
			no_matches.show()
		else:
			no_matches.hide()
		
		for i in range(len(search_results)):
			if i >= len(games):
				search_results[i].hide()
			else:
				search_results[i].text = games[i]["name"]
				
				if "cover" in games[i]:
					search_results[i].cover_id = str(games[i]["cover"]["image_id"])
				else:
					search_results[i].cover_id = "nocover"
				search_results[i].show()


func select_game(cover_id): 
	var texture = await main.get_cover(cover_id)
	display.add_game(texture)


func text_changed():
	if len(search_bar.text) > 0:
		if search_bar.text[-1] == "\n":
			search()
