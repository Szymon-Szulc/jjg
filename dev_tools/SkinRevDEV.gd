extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal hide_ele
signal show_ele
signal update_label(count)

onready var background = $ColorRect
onready var player_body = $ColorRect/Jumper_show/Sprite
onready var player_trail = $ColorRect/Jumper_show/Points
onready var circle_static = $ColorRect/Circle1/Sprite
onready var circle_limited = $ColorRect/Circle2/Sprite
onready var circle_fill = $ColorRect/Circle2/Label/Sprite2

var element = 0
var elements 
var elements_name = ["background", "player_body_1","player_body_2","player_body_3","player_trail", "circle_fill" ,"circle_static","circle_limited"]
var elements_color = [Color(1,1,1) ,Color(1,1,1) ,Color(1,1,1) ,Color(1,1,1) ,Color(1,1,1) ,Color(1,1,1) ,Color(1,1,1) ,Color(1,1,1)]
var pro_elements_c = 0
var amount = 0
var pro_elements = [Color(1,1,1)]

# Called when the node enters the scene tree for the first time.
func _ready():
	$ColorRect/Circle1/Sprite.material = $ColorRect/Circle1/Sprite.material.duplicate()
	$ColorRect/elementLabel.text = elements_name[element]
	$ColorRect/Jumper_show/Points.add_point(Vector2(-17,57))
	$ColorRect/Jumper_show/Points.add_point(Vector2(11,-11))
	elements = [background, player_body,"","", player_trail ,circle_fill, circle_static, circle_limited]

func check_player():
	if(elements_name[element] == "player_body_1" || elements_name[element] == "player_body_2" || elements_name[element] == "player_body_3"):
		emit_signal("show_ele")
	else:
		emit_signal("hide_ele")

func _on_RightButton_pressed():
	if(element == elements_name.size()-1):
		element = -1
	element += 1
	$ColorRect/elementLabel.text = elements_name[element]
	check_player()


func _on_LeftButton_pressed():
	if(element == 0):
		element = elements_name.size()
	element -= 1
	$ColorRect/elementLabel.text = elements_name[element]
	check_player()
	

func convert_Color_to_Color8(color):
	var colorR = round(color[0] * 255)
	var colorG = round(color[1] * 255)
	var colorB = round(color[2] * 255)
	return Color8(colorR, colorG, colorB)

func changeShader(_element, shader, param):
	#print(_element.material)
	_element.material.set_shader_param(shader, param)
	elements_color[element] = param

func _on_ColorPicker_color_changed(color):
#var elements_name = ["background", "player_body_1","player_body_2","player_body_3","player_trail", "circle_fill" ,"circle_static","circle_limited"]
	
	if(element >= 1 && element <= 7 && element != 4 ):
		if(not (element >= 2 && element <= 3)):
			changeShader(elements[element], "color", color)
		elif element == 2:
			print("element 2")
			changeShader(player_body, "color2", color)			
		else:
			changeShader(player_body, "color3", color)			
			
	elif(element == 4):
		elements[element].gradient.set_color(1, color)
		elements_color[element] = color
	else:
		elements[4].gradient.set_color(0, color)
		$ColorRect.color = color
		elements_color[element] = color
		

func _on_Export_pressed():
	print("'NAME': {\n	'name': 'NAME',\n	'label': 'Name',")
	print("	'background': Color(",elements_color[0],"),")
	print("	'player_body': Color(",elements_color[1],"),")
	if(amount > 0):
		match amount:
			1:
				print("	'player_body_1': Color(", elements_color[2] ,"),")
			2:
				print("	'player_body_1': Color(", elements_color[2] ,"),")
				print("	'player_body_2': Color(", elements_color[3] ,"),")
		print("	'player_amount': ", amount ,",")
	print("	'player_trail': Color(",elements_color[4],"),")
	print("	'circle_fill': Color(",elements_color[5],"),")
	print("	'circle_static': Color(",elements_color[6],"),")
	print("	'circle_limited': Color(",elements_color[7],"),")
	print("	'cost': 0")
	print("},")
	
func update_shader():
	changeShader(player_body, "amount", amount+1)

func _on_Plus_pressed():
	pro_elements_c += 1
	if(pro_elements_c > 2):
		pro_elements_c = 2
	amount = pro_elements_c
	update_shader()
	emit_signal("update_label", pro_elements_c)


func _on_Minus_pressed():
	pro_elements_c -= 1
	if(pro_elements_c < 0):
		pro_elements_c = 0
	amount = pro_elements_c	
	update_shader()
	emit_signal("update_label", pro_elements_c)
	

