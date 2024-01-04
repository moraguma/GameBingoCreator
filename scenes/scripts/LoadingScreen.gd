extends ColorRect
class_name LoadingScreen


@onready var label = $Text


func display(text: String):
	label.text = "[center]%s" % [text]
	show()


func stop():
	hide()
