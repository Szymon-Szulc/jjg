extends CanvasLayer

onready var tween = $Tween
onready var version_label = get_node("MarginContainer2/Version/Label")

func appear():
	get_tree().call_group("buttons", "set_disabled", false)
	tween.interpolate_property(self, "offset:x", 500, 0, 0.5, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()
	
	
func disappear():
	get_tree().call_group("buttons", "set_disabled", true)
	tween.interpolate_property(self, "offset:x", 0, 500, 0.5, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()
	
func _ready():
	version_label.text = "Version: " + str(Settings.version)
	if Settings.dev_mode:
		version_label.text = "Version: " + str(Settings.version) + " DEV"



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
