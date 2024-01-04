extends RichTextLabel
class_name Console


const WAIT_TIME = 5.0


@onready var timer: Timer = $Timer


func write(msg: String):
	show()
	text += "> %s\n" % [msg]
	timer.start(WAIT_TIME)


func reset():
	text = ""
	hide()
