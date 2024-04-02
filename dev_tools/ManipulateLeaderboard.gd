extends Node2D

onready var nick_node = get_node("Nick")
onready var score_node = get_node("Score")



func _on_Add_pressed():
	var nick = nick_node.text
	var score = int(score_node.text)
	SilentWolf.Scores.persist_score(nick, score)


func _on_RESET_pressed():
	SilentWolf.Scores.wipe_leaderboard()
