extends Node

signal changeBackground

var buy_buttons = {true: preload("res://assets/images/buttons/buy.png"), false: preload("res://assets/images/buttons/check.png")}

var chosenSkin = Settings.theme
var actualSkin = Settings.theme
var value = 0
var mode = false

func _ready():
	$ColorRect/Circle1/Sprite.material = $ColorRect/Circle1/Sprite.material.duplicate()
	$ColorRect/Jumper_show/Sprite/Points.add_point(Vector2(-17,57))
	$ColorRect/Jumper_show/Sprite/Points.add_point(Vector2(11,-11))
	load_skin()
	


func init(selectedSkin):
	Settings.load_skin_list()
	if(chosenSkin.name == actualSkin.name):
		$ColorRect/Panel.modulate = Color8(0,255,0)
	else:
		$ColorRect/Panel.modulate = Color8(255,255,255)
	selectedSkin = Settings.color_schemes[selectedSkin]
	$ColorRect/Circle1/Sprite.material.set_shader_param("color", selectedSkin["circle_static"])
	$ColorRect/Circle2/Sprite.material.set_shader_param("color", selectedSkin["circle_limited"])
	$ColorRect/Jumper_show/Sprite.material.set_shader_param("color", selectedSkin["player_body"])
	$ColorRect/Jumper_show/Sprite/Points.gradient.set_color(1, selectedSkin["player_trail"])
	$ColorRect.color = selectedSkin["background"]
	$ColorRect/name_skin.text = selectedSkin.label
	$ColorRect/Circle2/Label/Sprite2.material.set_shader_param("color", selectedSkin["circle_fill"])
	print(Settings.own_skin_list)
	if(Settings.own_skin_list.find(selectedSkin["name"]) == -1):
		$Blur.visible = true
		$Blur/Sprite/Sprite/Label.text = str(selectedSkin["cost"])
		mode = true
		changeMode("buy")
	else:
		$Blur.visible = false
		mode = false
		changeMode("select")

func changeMode(mode_name):
	match mode_name:
		"buy":
			get_node("../../Buttons3/Confirm").texture_normal = buy_buttons[true]
			
		"select":
			get_node("../../Buttons3/Confirm").texture_normal = buy_buttons[false]
			
	print("ustawiony: ", mode_name)

func left():
	value = Settings.skin_list.find(chosenSkin.name) - 1
	chosenSkin = Settings.color_schemes[Settings.skin_list[value]]
	init(chosenSkin.name)

func right():
	value = Settings.skin_list.find(chosenSkin.name) + 1
	if(value >= Settings.skin_list.size()):
		value = 0
	chosenSkin = Settings.color_schemes[Settings.skin_list[value]]
	init(chosenSkin.name)
	
func set_skin():
	print(Settings.own_skin_list)
	print("mode: " , mode)
	if (mode == false):
		print("wybrano skina %s" % chosenSkin.name)
		print(Settings.skin_list.find(chosenSkin.name))
		actualSkin = chosenSkin
		Settings.theme = actualSkin
		init(actualSkin.name)
		save_skin()
		emit_signal("changeBackground")
	else:
		print("kupowanie...")
		var cost_skin = chosenSkin.cost
		var coins = Settings.coins
		var own_list = Settings.own_skin_list
		if(coins >= cost_skin):
			own_list.insert(own_list.size(), chosenSkin.name)
			Settings.coins -= cost_skin
			Settings.save_coins()
			Settings.save_skin_list()
			print(Settings.own_skin_list)
			get_node("../../../Sprite/Label").text = str(Settings.coins)
			$Blur.visible = false
			mode = false
		else:
			print("nie stać cię biedaku :>")

func back():
	init(actualSkin.name)

func load_skin():
	var f = File.new()
	if f.file_exists(Settings.skin_file):
		f.open(Settings.skin_file, File.READ)
		actualSkin = f.get_var()
		chosenSkin = actualSkin
		Settings.theme = chosenSkin
		f.close()
	init(actualSkin.name)
		
func save_skin():
	var f = File.new()
	f.open(Settings.skin_file, File.WRITE)
	f.store_var(actualSkin)
	f.close()

