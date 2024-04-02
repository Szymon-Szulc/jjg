extends CanvasLayer

signal update_skin(skin)
signal change_background()

onready var tween = $Tween
onready var coin_label = get_node("MarginContainer/Sprite/Label")
onready var skinsRev = get_tree().get_nodes_in_group("skinsRev")
var skin_list = Settings.skin_list
var select_skin = Settings.color_schemes["NEON1"]
var page = 0
var pages = 0

func _ready():
	for skinRev in skinsRev:
		var value = int(skinRev.name[-1])
		var skin = Settings.color_schemes[skin_list[value-1]]
		skinRev.showSkin(skin)
		skinRev.connect("touch", self, "_click")
		Settings.load_skin_list()
		pages = ceil(Settings.skin_list.size() / 6.0 - 1)
		refresh_page()
		print("Wszystkich: ", skin_list.size())

func refresh_page():
	# value - 1 + (page * 6)
	#  1 - 1 + (0 * 6) = 0
	# 2 - 1 + (0*6) = 1
	# 5 - 1 + (1*6) = 4 + 6 = 10
	for skinRev in skinsRev:
		var value = int(skinRev.name[-1])
		var skin_num = value - 1 + (page * 6)
		if skin_list.size() > skin_num:
			skinRev.visible = true
			skinRev.showSkin(Settings.color_schemes[Settings.skin_list[skin_num]])
		else:
			skinRev.visible = false
		#skinRev.showSkin()

func next_page():
	page += 1
	if page > pages:
		page = 0
	print(page)
	refresh_page()

func prev_page():
	page -= 1
	if page < 0:
		page = pages
	print(page)	
	refresh_page()

func _click(skin, buy_mode, element):
	if buy_mode:
		if Settings.coins >= skin.cost:
			Settings.coins -= skin.cost
			coin_label.text = str(Settings.coins)
			Settings.own_skin_list.insert(Settings.own_skin_list.size(), skin.name)
			element.showSkin(skin)
			Settings.save_coins()
			Settings.save_skin_list()
		else:
			element.change_frame(Color(1,0,0))
			yield(get_tree().create_timer(0.8), "timeout")
			element.change_frame(Color(1,1,1))
			
	else:
		for skinRev in skinsRev:
			skinRev.change_frame(Color(1,1,1))
		Settings.theme = skin
		element.change_frame(Color(0,1,0))
		print("Wybrales skina " + skin.name)
		emit_signal("update_skin", skin)
		emit_signal("change_background")
		Settings.save_skin()
		

func appear():
	coin_label.text = str(Settings.coins)
	get_tree().call_group("buttons", "set_disabled", false)
	tween.interpolate_property(self, "offset:x", 500, 0, 0.5, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()
	
	
func disappear():
	get_tree().call_group("buttons", "set_disabled", true)
	tween.interpolate_property(self, "offset:x", 0, 500, 0.5, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()

