extends TextureButton
class_name CoverButton

var texture

@onready var display: GameDisplay = $"../../../"


func _ready():
	texture_normal = texture
	size = Vector2(165, 220)


func clicked():
	display.delete_game(self)
