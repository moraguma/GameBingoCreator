extends Control
class_name GameSelector

const CLIENT_ID = "gbtqx5oyln41nkscr4zgyufgn73q51"
@onready var CLIENT_SECRET = FileAccess.get_file_as_string("res://resources/data/client_secret.txt").replace("\n", "") # File stores client secret


var authentication_headers: PackedStringArray


@onready var loading_screen: LoadingScreen = $LoadingScreen
@onready var http_request = $HTTPRequest

@onready var console: RichTextLabel = $Console

# --------------------------------------------------------------------------------------------------
# API CALLS
# --------------------------------------------------------------------------------------------------

func _ready():
	# Gets token from client id and secret
	var url = "https://id.twitch.tv/oauth2/token?client_id=%s&client_secret=%s&grant_type=client_credentials" % [CLIENT_ID, CLIENT_SECRET]
	var error = http_request.request(url, [], HTTPClient.METHOD_POST, "")
	if error != OK:
		push_error("An error occured - " + str(error))
	
	loading_screen.display("AUTHENTICATING")
	var result = await http_request.request_completed # result, response_code, headers, body
	loading_screen.stop()
	var content = JSON.parse_string(result[3].get_string_from_utf8())
	
	authentication_headers = [
		"Client-ID: %s" % [CLIENT_ID],
		"Authorization: Bearer %s" % [content["access_token"]]
	]


## Returns up to 10 game titles from the IGDB based on the given keyword. Result
## is given as a list of dictionaries with the entries id, name and cover
func search_for_titles(keyword: String) -> Array:
	var url = "https://api.igdb.com/v4/games"
	var body = "search \"%s\"; fields name, cover.image_id; where version_parent = null & category = (0,1,2); limit 12;" % keyword
	make_request(url, authentication_headers, HTTPClient.METHOD_POST, body)
	
	loading_screen.display("SEARCHING")
	
	var result = await http_request.request_completed # result, response_code, headers, body
	loading_screen.stop()
	var games = JSON.parse_string(result[3].get_string_from_utf8())
	
	return games


## Given a game, searches for its cover image and loads it into a texture
func get_cover(image_id: String) -> Texture:
	# Load cover image
	make_request("https://images.igdb.com/igdb/image/upload/t_cover_big/%s.png" % image_id)
	
	loading_screen.display("FETCHING")
	var result = await http_request.request_completed # result, response_code, headers, body
	loading_screen.stop()
	
	if result[0] != HTTPRequest.RESULT_SUCCESS:
		push_error("Image couldn't be downloaded")
	
	var image = Image.new()
	var error = image.load_png_from_buffer(result[3])
	if error != OK:
		push_error("Couldn't load image")
	
	var texture = ImageTexture.create_from_image(image)
	return texture


# --------------------------------------------------------------------------------------------------
# UTILS
# --------------------------------------------------------------------------------------------------

func make_request(url, headers=PackedStringArray(), type=0, body=""):
	var error = http_request.request(url, headers, type, body)
	if error != OK:
		push_error("An error occurred - " + str(error))
