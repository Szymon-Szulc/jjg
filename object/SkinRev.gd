extends Control

signal touch(skin, buy_mode, element)

onready var backgroud = get_node("background")
onready var circle_limited = get_node("background/circle_limited/Sprite")
onready var circle_fill = get_node("background/circle_limited/Label/circle_fill")
onready var circle_static = get_node("background/circle_static/Sprite")
onready var player_body = get_node("background/jumper/Sprite")
onready var player_trail = get_node("background/jumper/Sprite/trail")
onready var blur = get_node("blur")
onready var name_tag = get_node("background/name_skin")
onready var frame = get_node("background/frame")
onready var cost_label = get_node("blur/blur/Control/HBoxContainer/value")
onready var cost_container = get_node("blur/blur/Control/HBoxContainer/Sprite2")

var own = false
var buy_mode = true
var skin_show = Settings.color_schemes["CLA"]

func _ready():
	player_trail.add_point(Vector2(-25,59))
	player_trail.add_point(Vector2(10,-9))
	circle_limited.material = circle_limited.material.duplicate()
	circle_fill.material = circle_fill.material.duplicate()
	circle_static.material = circle_static.material.duplicate()
	player_body.material = player_body.material.duplicate()
	player_trail.gradient = player_trail.gradient.duplicate()
	Settings.load_skin()
	showSkin(Settings.theme)

func change_frame(color):
	frame.modulate = color

func check_type_skin(element, skin):
	if(skin.has("player_amount")):
		match skin.player_amount:
			2:
				element.material.set_shader_param("amount", 2)
				element.material.set_shader_param("color2", skin.player_body_1)
				element.material.set_shader_param("color3", Color(1,1,1))	
			3:
				element.material.set_shader_param("amount", 3)		
				element.material.set_shader_param("color2", skin.player_body_1)
				element.material.set_shader_param("color3", skin.player_body_2)		
	else:
		element.material.set_shader_param("amount", 1)
		element.material.set_shader_param("color2", Color(1,1,1))
		element.material.set_shader_param("color3", Color(1,1,1))

func change_shader(element, color):
	element.material.set_shader_param("color", color)

func showSkin(skin):

	if(Settings.theme.name == skin.name):
		change_frame(Color(0,1,0))
	else:
		change_frame(Color(1,1,1))
	var own_skins = Settings.own_skin_list
	own = own_skins.has(skin.name)
	skin_show = skin
	#ustawienie nazwy
	name_tag.text = skin.label
	cost_label.text = str(skin.cost)
	#zmiana tła
	backgroud.color = skin.background
	#zmiana kółek
	change_shader(circle_static, skin.circle_static)
	change_shader(circle_limited, skin.circle_limited)
	change_shader(circle_fill, skin.circle_fill)
	#zmiana koloru gracza
	check_type_skin(player_body, skin)
	change_shader(player_body, skin.player_body)
	player_trail.gradient.set_color(1, skin.player_trail)
	player_trail.gradient.set_color(0, skin.background)
	#czy gracz NIE posiada skina?
	
	if(!own):
		set_mode(true)
	else:
		set_mode(false)

func set_mode(_mode):
	buy_mode = _mode
	match buy_mode:
		true:
			blur.visible = true
		false:
			blur.visible = false

func _on_SkinRev_gui_input(event):
	if event is InputEventScreenTouch and event.pressed:
		emit_signal("touch", skin_show, buy_mode, self)
