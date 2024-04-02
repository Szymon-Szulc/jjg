extends HBoxContainer


func _on_Coins_pressed():
	Settings.coinsDevMode = !Settings.coinsDevMode
	$Coins.text = "Coins " + str(Settings.coinsDevMode)
