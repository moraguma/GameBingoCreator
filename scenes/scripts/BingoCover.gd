extends Control
class_name BingoCover


@onready var cover = $Cover
@onready var shadow = $Shadow


func set_tex(texture: Texture):
	cover.show()
	shadow.show()
	cover.texture = texture


func make_free_space():
	cover.hide()
	shadow.hide()
