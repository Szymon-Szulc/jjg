extends Node

signal start_game

var sound_buttons = {true: preload("res://assets/images/buttons/audioOn.png"), false: preload("res://assets/images/buttons/audioOff.png")}
var music_buttons = {true: preload("res://assets/images/buttons/musicOn.png"), false: preload("res://assets/images/buttons/musicOff.png")}
var nick
var current_screen = null

func _ready():
	
	yield(get_tree().create_timer(0.1), "timeout")
	register_buttons()
	load_nick()
	if(Settings.nick == ""):
		change_screen($FirstPlayScreen)
	else:
		load_nick()
		change_screen($TitleScreen)
	$TitleScreen/MarginContainer/VBoxContainer/Label/Welcome.text = "Welcome " + Settings.nick + "!"
	Settings.load_coins()
	Settings.load_settings()
	
func register_buttons():
	var buttons = get_tree().get_nodes_in_group("buttons")
	for button in buttons:
		button.connect("pressed", self, "_on_button_pressed", [button])
	
func _on_button_pressed(button):
	if Settings.enable_sound:
		$Click.play()
	match button.name:
		"Home":
			load_nick()
			change_screen($TitleScreen)
		"Play":
			change_screen(null)
			yield(get_tree().create_timer(0.8), "timeout")
			emit_signal("start_game")
		"Settings":
			get_node("SettingsScreen/MarginContainer/VBoxContainer/Buttons/Music").texture_normal = music_buttons[Settings.enable_music]
			get_node("SettingsScreen/MarginContainer/VBoxContainer/Buttons/Sound").texture_normal = sound_buttons[Settings.enable_sound]
			if Settings.dev_mode:
				get_node("SettingsScreen/MarginContainer/VBoxContainer/DEV").visible = true
			change_screen($SettingsScreen)
		"Sound":
			Settings.enable_sound = !Settings.enable_sound
			button.texture_normal = sound_buttons[Settings.enable_sound]
		"Music":
			Settings.enable_music = !Settings.enable_music
			button.texture_normal = music_buttons[Settings.enable_music]
		"Return":
			Settings.save_settings()
			change_screen($TitleScreen)
		"Skin":
			change_screen($SkinsScreen)
		"SetNick":
			set_nick()
		"Trophy":
			$LeaderboardScreen/MarginContainer/VBoxContainer/VBoxContainer.init()
			change_screen($LeaderboardScreen)

func _unhandled_input(event):
	if current_screen == $FirstPlayScreen:
		if event is InputEventKey:
			if event.scancode == 16777221:
				set_nick()

func set_nick():
	nick = $FirstPlayScreen/MarginContainer/VBoxContainer/Input/Edit.text
	if(nick != ""):
		Settings.nick = nick
		save_nick()
		$TitleScreen/MarginContainer/VBoxContainer/Label/Welcome.text = "Welcome " + Settings.nick + "!"
		change_screen($TitleScreen)
	else:
		$FirstPlay/Error.popup_centered(Vector2(0,0))

func save_nick():
	var f = File.new()
	f.open(Settings.nick_file, File.WRITE)
	f.store_var(nick)
	f.close()

func load_nick():
	var f = File.new()
	if f.file_exists(Settings.nick_file):
		
		f.open(Settings.nick_file, File.READ)
		nick = f.get_var()
		Settings.nick = nick
		f.close()

func change_screen(new_screen):
	if current_screen:
		current_screen.disappear()
		yield(current_screen.tween, "tween_completed")
	current_screen = new_screen
	if new_screen:
		current_screen.appear()
		yield(current_screen.tween, "tween_completed")
		

func game_over(score, highscore, coins):
	var score_box = $GameOverScreen/MarginContainer/VBoxContainer/Scores
	score_box.get_node("Score").text = "Score: %s" % score
	score_box.get_node("Coins").text = "Coins: %s" % coins
	Settings.coins += coins
	Settings.save_coins()
	score_box.get_node("Best").text = "Best: %s" % highscore
	change_screen($GameOverScreen)
