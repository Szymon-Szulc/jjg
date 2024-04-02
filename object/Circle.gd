extends Area2D

onready var coin = $Pivot_Coin/Coin
onready var orbit_position = $Pivot/OrbitPosition
onready var move_tween = $MoveTween

enum MODES {STATIC, LIMITED}


var radius = 150
var rotation_speed = PI
var mode = MODES.STATIC
var move_range = 0
var move_speed = 1.0
var num_orbits = 3
var current_orbit = 0
var orbit_start = null
var jumper = null

func init(_position, level=1):
	$Pivot_Coin.rotation = 0
	var _mode = Settings.rand_weighted([10, level-1])
	#var _mode = MODES.LIMITED
	set_mode(_mode)
	position = _position
	var move_chance = min(0.9, max(0, (level-10) / 10.0))
	if randf() < move_chance:
		move_range = max(25, 100 * rand_range(0.75, 1.25) * move_chance) * pow(-1, randi() % 2)
		move_speed = max(2.5 - ceil(level/5)*0.25, 0.75)
	var small_chance = min(0.9, max(0, (level-10) / 20.0))
	#small_chance = 2
	if randf() < small_chance:
		radius = max(100, radius - level * rand_range(0.75, 1.25))
	var coin_chanse = min(0.5, max(0, (level - 5) / 50.0))
	if Settings.coinsDevMode:
		coin_chanse = 1
	if randf() < coin_chanse:
		coin.visible = true
		coin.monitorable = true
		$Pivot_Coin/Coin.position.y = -radius + 10
	
	$Sprite.material = $Sprite.material.duplicate()
	$SpriteEffect.material = $Sprite.material
	$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate()
	$CollisionShape2D.shape.radius = radius - 38
	var img_size = $Sprite.texture.get_size().x / 2
	$Sprite.scale = Vector2(1,1) * radius / img_size
	orbit_position.position.x = radius - 25
	rotation_speed *= pow(-1, randi() % 2)
	set_tween()

func set_mode(_mode):
	mode = _mode
	var color
	match mode:
		MODES.STATIC:
			$Label.hide()
			color = Settings.theme["circle_static"]
		MODES.LIMITED:
			current_orbit = num_orbits
			$Label.text = str(current_orbit)
			$Label.show()
			color = Settings.theme["circle_limited"]
	$Sprite.material.set_shader_param("color", color)
			

func _process(delta):
	$Pivot.rotation += rotation_speed * delta
	$Pivot_Coin.rotation += rotation_speed*-1/4 * delta
	if mode == MODES.LIMITED and jumper:
		check_orbits()
		update()
		
func check_orbits():
	if abs($Pivot.rotation - orbit_start) > 2 * PI:
		current_orbit -= 1
		if Settings.enable_sound:
			$Beep.play()
		$Label.text = str(current_orbit)
		if current_orbit <= 0:
			jumper.die()
			jumper = null
			implode()
		orbit_start = $Pivot.rotation
		
func implode():
	$AnimationPlayer.play("implode")
	yield($AnimationPlayer, "animation_finished")
	queue_free()

func capture(target):
	jumper = target
	$AnimationPlayer.play("Capture")
	$Pivot.rotation = (jumper.position - position).angle()
	orbit_start = $Pivot.rotation

func _draw():
	if jumper:
		var r = ((radius - 75) / num_orbits) * (1 + num_orbits - current_orbit)
		draw_circle_arc_poly(Vector2.ZERO, r+10, orbit_start + PI/2, $Pivot.rotation + PI/2, Settings.theme["circle_fill"])

func draw_circle_arc_poly(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PoolVector2Array()
	points_arc.push_back(center)
	var colors = PoolColorArray([color])

	for i in range(nb_points + 1):
		var angle_point = angle_from + i * (angle_to - angle_from) / nb_points - PI/2
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	draw_polygon(points_arc, colors)

func set_tween(object=null, key=null):
	if move_range == 0:
		return
	move_range *= -1
	move_tween.interpolate_property(self, "position:x", position.x, position.x + move_range, move_speed, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	move_tween.start()
