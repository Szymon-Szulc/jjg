extends CanvasLayer

func _ready():
	$Message.rect_pivot_offset = $Message.rect_size / 2

func show_message(text):
	$Message.text = text
	$AnimationPlayer.play("show_message")
	
func hide():
	$ScoreBox.hide()

func show():
	$ScoreBox.show()

func update_score(value):
	$ScoreBox/HBoxContainer/Score.text = str(value)

func update_coin(value):
	$ScoreBox/HBoxContainer/Sprite/Label.text = str(value)
