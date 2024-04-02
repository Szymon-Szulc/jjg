extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var color 

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.material = $Sprite.material.duplicate()
	if(get_node(".").name == "Circle"):
		color = Settings.color_schemes["CLA"]["circle_static"]
	else:
		color = Settings.color_schemes["CLA"]["circle_limited"]
	
	$Sprite.material.set_shader_param("color", color)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
