extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var label = get_node("VBoxContainer2/Label")
# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SkinRev_update_label(count):
	label.text = str(count)


func _on_SkinRev_hide_ele():
	self.visible = false


func _on_SkinRev_show_ele():
	self.visible = true
