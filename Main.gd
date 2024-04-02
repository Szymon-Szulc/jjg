extends Node2D

onready var admob = $AdMob

var Circle = preload("res://object/Circle.tscn")
var Jumper = preload("res://object/Jumper.tscn")

const secure_value = 20
var texture = preload("res://assets/images/background/CIRCLE.png")
var random_secure_value = ceil(randf()*10)
var secure_coins = 0 setget anticheat_coins
var secure_score = 0 setget anticheat_score
var player
var highscore = 0
var score = 0 setget set_score
var coins = 0 setget set_coins
var level = 0
var devCoins = false

func change_background():
	$Background/ColorRect.color = Settings.theme["background"]
	$Background/CPUParticles2D.set_color(Settings.theme["circle_static"])
	$Background/CPUParticles2D.set_texture(texture)
	if Settings.theme.has("backgroud_texture"):		
		$Background/CPUParticles2D.set_texture(load(Settings.theme["backgroud_texture"]))

func _ready():
	change_background()
	randomize()
	load_score()
	$HUD.hide()
	#admob.load_banner()
	#admob.show_banner()
	#reset_score()

func new_game():
	#admob.hide_banner()
	#var score_id = yield(SilentWolf.Scores.persist_score("IceThief8", 111), "sw_score_posted")
	self.coins = 0
	self.score = -1
	#anticheat_init
	random_secure_value = ceil(randf()*10)
	secure_score = -(20 + random_secure_value)
	secure_coins = 0

	level = 0
	$HUD.update_score(score)
	$Camera2D.position = $StartPosition.position
	player = Jumper.instance()
	player.position = $StartPosition.position
	add_child(player)
	player.connect("captured", self, "_on_Jumper_captured")
	player.connect("coin_catch", self, "_on_Coin_catch")
	player.connect("died", self, "_on_Jumper_died")
	spawn_circle($StartPosition.position)
	$HUD.show()
	$HUD.show_message("Go!")
	if Settings.enable_music:
		$Music.play()
	
func spawn_circle(_position=null):
	var c = Circle.instance()
	if !_position:
		var x = rand_range(-150, 150)
		var y = rand_range(-500, -400)
		_position = player.target.position + Vector2(x, y)
	add_child(c)
	c.init(_position, level)
	
func _on_Jumper_captured(object):
	$Camera2D.position = object.position
	call_deferred("spawn_circle")
	object.capture(player)
	self.score += 1
	self.secure_score += (secure_value + random_secure_value)

func _on_Coin_catch(object):
	object.visible = false
	self.coins += 1
	object.set_deferred("monitorable", false)
	self.secure_coins += (secure_value + random_secure_value)

func set_coins(value):
	coins = value
	$HUD.update_coin(value)

func set_score(value):
	score = value
	$HUD.update_score(score)
	if score > 0 and score % Settings.circles_per_level == 0:
		level += 1
		$HUD.show_message("Level %s" % str(level))

func anticheat_score(value):
	secure_score = value
	#print(secure_score/(secure_value + random_secure_value))
	if(score !=  secure_score/(secure_value + random_secure_value)):
		$HUD.show_message("CHEATER!")
		print("CHEATER")

func anticheat_coins(value):
	secure_coins = value
	print(secure_coins/(secure_value + random_secure_value))
	if(coins !=  secure_coins/(secure_value + random_secure_value)):
		$HUD.show_message("CHEATER!")
		print("CHEATER")
		
func _on_Jumper_died():
	#admob.show_banner()
	if(coins !=  secure_coins/(secure_value + random_secure_value)):
		coins = -10
	if(score !=  secure_score/(secure_value + random_secure_value)):
		score = -10
	if score > highscore:
		highscore = score
		save_score()
	get_tree().call_group("circle", "implode")
	$Screens.game_over(score, highscore, coins)
	$HUD.hide()
	if Settings.enable_music:
		$Music.stop()


func load_score():
	var f = File.new()
	if f.file_exists(Settings.score_file):
		f.open(Settings.score_file, File.READ)
		highscore = f.get_var()
		f.close()
		
func save_score():
	SilentWolf.Scores.persist_score(Settings.nick, highscore)
	var f = File.new()
	f.open(Settings.score_file, File.WRITE)
	f.store_var(highscore)
	f.close()


