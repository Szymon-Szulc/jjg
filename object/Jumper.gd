extends Area2D

signal captured 
signal coin_catch
signal died

onready var trail = $Trial/Points

var velocity = Vector2(100, 0)
var jump_speed = 1000
var target = null
var trail_length = 25

func _ready():
	if Settings.theme.has('player_amount'):
		$Sprite.material.set_shader_param("amount", Settings.theme["player_amount"])
		$Sprite.material.set_shader_param("color2", Settings.theme["player_body_1"])
		if Settings.theme.has('player_body_2'):
			$Sprite.material.set_shader_param("color3", Settings.theme["player_body_2"])
	else:
		$Sprite.material.set_shader_param("amount", 1)


	$Sprite.material.set_shader_param("color", Settings.theme["player_body"])
	trail.gradient.set_color(1, Settings.theme["player_trail"])
	trail.gradient.set_color(0, Settings.theme["background"])


func _unhandled_input(event):
	if target and event is InputEventScreenTouch and event.is_pressed():
		jump()


func jump():
	target.implode()
	target = null
	velocity = transform.x * jump_speed
	if Settings.enable_sound:
		$Jump.play()


func _on_Jumper_area_entered(area):
	if(area.name != "Coin"):
		target = area
		velocity = Vector2.ZERO
		emit_signal("captured", area)
		if Settings.enable_sound:
			$Capture.play()
	else:
		emit_signal("coin_catch", area)
	
	
func _physics_process(delta):
	if($Sprite.visible == false):
		die()
	if trail.points.size() > trail_length:
		trail.remove_point(0)
	trail.add_point(position)

	if target:
		transform = target.orbit_position.global_transform
	else:
		position += velocity * delta
		
		
func die():
	target = null
	queue_free()
	print("ŚMIERĆ")


func _on_VisibilityNotifier2D_screen_exited():
	if !target:
		emit_signal("died")
		die()
