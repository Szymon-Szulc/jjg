extends Node

var dev_mode = false
var coinsDevMode = false
var version = 4
var nick_file = "user://nick.save"
var score_file = "user://highscore.save"
var skin_file = "user://skin.save"
var settings_file = "user://settings.save"
var coin_file = "user://coin.save"
var own_skin_file = "user://own_skin.save"
var coins = 0
var enable_sound = true
var enable_music = true
var nick = ""

var circles_per_level = 5

var own_skin_list = ["CLA","UKRAINE"]

var skin_list = ["CLA","GREEN","NEON1","NEON2",'NEON3',"NEON4","PINK","PUR","VIO","UKRAINE"
	,"CANDY","COFFE","COL","GOLD","HEAVEN","HELL","HON","LIGHTNING",'VAL',"SPRING","AUTUMN","WINTER","SUMMER","GOLD2", ]

#CENY:
#	NEON PO 10
#	REKOLORY PO 50
#	MOTYWY PO 100
# 	PORY ROKU PO 250

var color_schemes = {
	'CLA': {
		'name': 'CLA',
		'label': 'Classic',
		'background': Color(0,0,0,1),
		'player_body': Color(0.984314,0.713726,0.086275,1),
		'player_trail': Color(1,1,1,1),
		'circle_fill': Color(0.023062,1,0.653275,1),
		'circle_static': Color(0.980392,0.439216,0.556863,1),
		'circle_limited': Color(0,0.662745,0.972549,1),
		'cost': 0
	},
	'GREEN': {
		'name': 'GREEN',
		'label': 'Loser',
		'background': Color(0.740614,0.797647,0.693306,1),
		'player_body': Color(0.176357,0.388967,0,1),
		'player_trail': Color(0.449532,0.57599,0.344637,1),
		'circle_fill': Color(0.327666,0.610624,0.092956,1),
		'circle_static': Color(0.456053,1,0.004856,1),
		'circle_limited': Color(0.742233,0.634979,0.071601,1),
		'cost': 1
	},
	"NEON1": {
		'name': "NEON1",
		'label': "Neon 1",
		'background': Color8(0, 0, 0),
		'player_body': Color8(203, 255, 0),
		'player_trail': Color8(204, 255, 0 ),
		'circle_fill': Color8(255, 0, 110),
		'circle_static': Color8(0, 255, 102),
		'circle_limited': Color8(204, 0, 255),
		'cost': 10,
	},
	"NEON2": {
		'name': "NEON2",	
		'label': "Neon 2",		
		'background': Color8(0, 0, 0),
		'player_body': Color8(246, 255, 255),
		'player_trail': Color8(255, 255, 255),
		'circle_fill': Color8(255, 0, 110),
		'circle_static': Color8(151, 255, 48),
		'circle_limited': Color8(127, 0, 255),
		'cost': 10,	
	},
	"NEON3": {
		'name': "NEON3",
		'label': "Neon 3",		
		'background': Color8(0, 0, 0),
		'player_body': Color8(255, 0, 187),
		'player_trail': Color8(255, 0, 148),
		'circle_fill': Color8(255, 148, 0),
		'circle_static': Color8(170, 255, 0),
		'circle_limited': Color8(204, 0, 255),
		'cost': 10,	
	},
	'NEON4': {
		'name': 'NEON4',
		'label': "Neon 4",
		'background': Color(0.232294,0,0.211854,1),
		'player_body': Color(1,1,1,1),
		'player_trail': Color(1,1,1,1),
		'circle_fill': Color8(255,0,0),
		'circle_static': Color(0,1,0.594185,1),
		'circle_limited': Color(0,0.810702,1,1),
		'cost': 10,		
	},
	'VIO': {
		'name': 'VIO',
		'label': 'Violet',
		'background': Color(0.07451,0.003922,0.070588,1),
		'player_body': Color(0.521569,0.278431,0.596078,1),
		'player_trail': Color(0.486275,0.447059,0.627451,1),
		'circle_fill': Color(0.133333,0.454902,0.647059,1),
		'circle_static':Color(0.407843,0.054902,0.294118,1) ,
		'circle_limited':Color(0.486275,0.137255,0.54902,1),
		'cost': 50,
	},
	'PINK': {
		'name': 'PINK',
		'label': 'Pink',
		'background': Color(0.180392,0.027451,0.070588,1),
		'player_body': Color(1,0.701961,0.756863,1),
		'player_trail': Color(1,0.301961,0.427451,1),
		'circle_fill': Color(0.643137,0.07451,0.235294,1),
		'circle_static': Color(1,0.768627,0.839216,1),
		'circle_limited': Color(0.501961,0.058824,0.184314,1),
		'cost': 50,
	},
	'GOLD': {
		'name': 'GOLD',
		'label': 'Gold & Silver',
		'background': Color(0,0,0,1),
		'player_body': Color(1,0.921569,0.329412,1),
		'player_trail': Color(1,0.792157,0.117647,1),
		'circle_fill': Color(0.581473,0.581473,0.581473,1),
		'circle_static': Color(0.517647,0.513726,0.513726,1),
		'circle_limited': Color(0.709804,0.709804,0.709804,1),
		'cost':100,
	},
	'COFFE': {
		'name': 'COFFE',
		'label': 'Coffe',
		'background': Color(0,0,0,1),
		'player_body': Color(0.662745,0.443137,0.294118,1),
		'player_trail': Color(0.552941,0.827451,0.87451,1),
		'circle_fill': Color(0.678431,0.341176,0.2,1),
		'circle_static': Color(0.909804,0.596078,0.368627,1),
		'circle_limited': Color(0.423529,0.231373,0.117647,1),
		'backgroud_texture': "res://assets/images/background/COFFE.png",
		'cost': 100,
	},
	'HEAVEN': {
		'name': 'HEAVEN',
		'label': 'Heaven',
		'background': Color(0.047059,0.098039,0.145098,1),
		'player_body': Color(0.105882,0.596078,0.878431,1),
		'player_trail': Color(0.909804,0.945098,0.94902,1),
		'circle_fill': Color(0.043137,0.258824,0.356863,1),
		'circle_static': Color(0,0.54902,0.811765,1),
		'circle_limited': Color(0.141176,0.482353,0.627451,1),
		'cost': 100,
	},
	'HON': {
		'name': 'HON',
		'label': 'Honeycomb',
		'background': Color(0.168627,0.105882,0.011765,1),
		'player_body': Color(1,0.823529,0.121569,1),
		'player_trail': Color(0.431373,0.356863,0.047059,1),
		'circle_fill': Color(0.870588,0.588235,0.070588,1),
		'circle_static': Color(0.972549,0.717647,0.258824,1),
		'circle_limited': Color(0.968627,0.647059,0.047059,1),
		'backgroud_texture': "res://assets/images/background/HONEYCOMB.png",
		'cost': 100,
	},
	'LIGHTNING': {
		'name': 'LIGHTNING',
		'label': 'Lightning',
		'background': Color(0.363408,0.36227,0.385259,1),
		'player_body': Color(0.910985,1,0,1),
		'player_trail': Color(0.622654,0.896721,0.480727,1),
		'circle_fill': Color(0.489197,0.487661,0.505603,1),
		'circle_static': Color(0.105882,0.043137,0.764706,1),
		'circle_limited': Color(0.566114,0.52947,0.950876,1),
		'cost': 100
	},
	"COL": {
		'name': "COL",
		'label': "Toothpaste",
		'background': Color8(0,0,0),
		'player_body': Color8(255,255,255),
		'player_trail': Color8(105, 146, 207),
		'circle_fill': Color8(230, 9, 101),
		'circle_static': Color8(40, 122, 148),
		'circle_limited': Color8(232, 37, 66),
		'cost': 100,
	},
	'CANDY': {
		'name': 'CANDY',
		'label': 'Candy Shop',
		'background': Color(0.36126,0.27803,0.323531,1),
		'player_body': Color(0.853062,0.608956,0.823569,1),
		'player_trail': Color(0.603698,0.370833,0.575563,1),
		'circle_fill': Color(0.289608,0,1,1),
		'circle_static': Color(1,0,0.546694,1),
		'circle_limited': Color(0.252756,0.113287,0.53443,1),
		'backgroud_texture': "res://assets/images/background/CANDY.png",
		'cost': 100
	},
	"VAL": {
		'name': "VAL",
		'label': "Valentine",
		'background': Color8(50, 50, 50),
		'player_body': Color8(250, 78, 171),
		'player_trail': Color8(254, 131, 198),
		'circle_fill': Color8(230, 9, 101),
		'circle_static': Color8(230, 9, 101),
		'circle_limited': Color8(255, 161, 201),
		'cost': 100,
	},
	'AUTUMN': {
		'name': 'AUTUMN',
		'label': 'Autumn',
		'background': Color(0.908476,0.729085,0.572524,1),
		'player_body': Color(0.430528,0.077543,0.077543,1),
		'player_trail': Color(0.569063,0.170494,0.170494,1),
		'circle_fill': Color(0.887695,0.372032,0.372032,1),
		'circle_static': Color(1,0.513281,0.088501,1),
		'circle_limited': Color(0.811501,0.273327,0.159091,1),
		'backgroud_texture': "res://assets/images/background/AUTUMN.png",
		'cost': 250
	},
	'WINTER': {
		'name': 'WINTER',
		'label': 'Winter',
		'background': Color(0.007843,0.007843,0.12549,1),
		'player_body': Color(0.678431,0.909804,0.956863,1),
		'player_trail': Color(0.792157,0.941176,0.972549,1),
		'circle_fill': Color(0,0.466667,0.713726,1),
		'circle_static': Color(0.282353,0.792157,0.894118,1),
		'circle_limited': Color(0,0.466667,0.713726,1),
		'backgroud_texture': "res://assets/images/background/WINTER.png",
		'cost': 250,
	},
	'SPRING': {
		'name': 'SPRING',
		'label': 'Spring',
		'background': Color(0.424104,0.579575,0.672965,1),
		'player_body': Color(0.178058,0.437455,0.073564,1),
		'player_trail': Color(0.608455,0.839208,0.5155,1),
		'circle_fill': Color(0.620402,0.991597,0.470872,1),
		'circle_static': Color(0.55271,0.859988,0.428928,1),
		'circle_limited': Color(0.896789,0.556009,0.929256,1),
		'backgroud_texture': "res://assets/images/background/SPRING.png",
		'cost': 250
	},
	'SUMMER': {
		'name': 'SUMMER',
		'label': 'Summer',
		'background': Color(0.705882,0.807843,0.937255,1),
		'player_body': Color(0.752941,0.403922,0.133333,1),
		'player_trail': Color(1,1,1,1),
		'circle_fill': Color(0.894118,0.694118,0.670588,1),
		'circle_static': Color(1,0.854902,0.039216,1),
		'circle_limited': Color(0.988235,0.67451,0.364706,1),
		'cost': 250
	},
	'GOLD2': {
		'name': 'GOLD2',
		'label': 'Pure Gold',
		'background': Color(0.501961,0.356863,0.062745,1),
		'player_body': Color(1,0.882353,0.411765,1),
		'player_trail': Color(1,0.972549,0.839216,1),
		'circle_fill': Color(0.929412,0.772549,0.192157,1),
		'circle_static': Color(0.788235,0.635294,0.152941,1),
		'circle_limited': Color(0.678431,0.533333,0.117647,1),
		'cost':1000,
	},
	'HELL': {
        'name': 'HELL',
        'label': 'Hell',
        'background': Color(0.043137,0.035294,0.039216,1),
        'player_body': Color(0.694118,0.654902,0.65098,1),
        'player_trail': Color(0.827451,0.827451,0.827451,1),
        'circle_fill': Color(0.898039,0.219608,0.231373,1),
        'circle_static': Color(0.729412,0.094118,0.105882,1),
        'circle_limited': Color(0.643137,0.086275,0.101961,1),
        'cost': 100
	},
	'UKRAINE': {
        'name': 'UKRAINE',
        'label': 'Ukraine',
        'background': Color(0,0,0,1),
        'player_body': Color(0,0.350448,1,1),
        'player_body_1': Color(1,0.803571,0,1),
        'player_amount': 2,
        'player_trail': Color(0.36942,0.36942,0.36942,1),
        'circle_fill': Color(0,0.316965,1,1),
        'circle_static': Color(0.995536,1,0,1),
        'circle_limited': Color(1,0.9375,0,1),
        'cost': 100
	},
	'PUR': {
        'name': 'PUR',
        'label': 'Purple',
        'background': Color(0.762275,0.781124,0.84933,1),
        'player_body': Color(0.161443,0.077293,0.631696,1),
        'player_trail': Color(0.904229,0.548366,1,1),
        'circle_fill': Color(0.680215,0.425055,0.748884,1),
        'circle_static': Color(0.053606,0,0.453125,1),
        'circle_limited': Color(0.341866,0,0.453125,1),
        'cost': 50
	},


}

var theme = color_schemes["CLA"]

static func rand_weighted(weights):
	var sum = 0
	for weight in weights:
		sum += weight
	var num = rand_range(0, sum)
	for i in weights.size():
		if num < weights[i]:
			return i
		num -= weights[i]

static func reset_score():
	var f = File.new()
	f.open(Settings.score_file, File.WRITE)
	f.store_var(0)
	f.close()

#lista skinow
func save_skin_list():
	var f = File.new()
	print(own_skin_list)
	f.open(own_skin_file, File.WRITE)
	f.store_var(own_skin_list)
	f.close()

func load_skin_list():
	var f = File.new()
	if f.file_exists(own_skin_file):
		f.open(own_skin_file, File.READ)
		own_skin_list = f.get_var()
	f.close() 

#skin
func save_skin():
	var f = File.new()
	f.open(skin_file, File.WRITE)
	f.store_var(theme)
	f.close()

func load_skin():
	var f = File.new()
	if f.file_exists(skin_file):
		f.open(skin_file, File.READ)
		theme = f.get_var()
	f.close()

#ustawienia
func save_settings():
	var f = File.new()
	f.open(settings_file, File.WRITE)
	f.store_var(enable_music)
	f.store_var(enable_sound)
	f.close()

func load_settings():
	var f = File.new()
	if f.file_exists(settings_file):
		f.open(settings_file, File.READ)
		enable_music = f.get_var()
		enable_sound = f.get_var()
	f.close()

#kasa
func save_coins():
	var f = File.new()
	f.open(coin_file, File.WRITE)
	f.store_var(coins)
	f.close()
	
func load_coins():
	var f = File.new()
	if f.file_exists(coin_file):
		f.open(coin_file, File.READ)
		coins = f.get_var()
		if(coins == null):
			coins = 0
		# if(dev_mode == true):
		# 	coins = skin_list.size() * 200
	f.close()
