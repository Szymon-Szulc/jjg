extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var scores
var position = 0
var panel
var panelname

func _ready():
	init()

# Called when the node enters the scene tree for the first time.
func init():
	position = 0
	yield(SilentWolf.Scores.get_high_scores(10), "sw_scores_received")
	scores = SilentWolf.Scores.scores
	for score in scores:
		position += 1
		panelname = "Panel"+str(position)
		panel = get_node(panelname)
		panel.get_child(0).get_child(0).text = str(position) + "#"
		panel.get_child(0).get_child(1).text = str(score.player_name)
		panel.get_child(0).get_child(2).text = str(score.score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
