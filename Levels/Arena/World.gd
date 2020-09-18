extends Node

# -------------------- DECLARE VARIABLES --------------------
onready var player_entities : Node = $Entities/Players

onready var player_spawn_points : Node2D = $Entities/Players/PlayerSpawnPoints

export var player_packed_scene : PackedScene



export var player_amount : int = 0

const PLAYER_INSTANCE_PATH : String = "res://Entities/Player/Player Base/Player.tscn"

var player_preload = load("res://Entities/Players/Player Base/Player.tscn")

var player_controllers_path : PoolStringArray = ["res://Entities/Players/Player Controllers/Keyboard Wasd/PlayerControllerKeyboardWasd.tscn",
"res://Entities/Players/Player Controllers/Keyboard Arrows/PlayerControllerKeyboardArrow.tscn",
"res://Entities/Players/Player Controllers/Joypad 0/PlayerControllerJoypadZero.tscn",
"res://Entities/Players/Player Controllers/Joypad 1/PlayerControllerJoypadOne.tscn"]
# --------------------  DECLARE SIGNALS  --------------------

# --------------------   RUN THE CODE    --------------------
func _ready() -> void:
	define_player_amount()
	spawn_all_players()


var player_controller
var player_instance
var player_colors : Dictionary = {"white" : "ffffff", "red" : "ff0000", "blue" : "000688", "orange" : "be4c00"}
var choosen_player_color = -1
func spawn_player(index : int) -> void:
	choosen_player_color += 1
	# Instance one player
	player_instance = player_packed_scene.instance()

	# Attach the controller to the player
	player_controller = load(player_controllers_path[index])
	var player_controller_instance = player_controller.instance()
	player_instance.add_child(player_controller_instance)
	player_instance.set_modulate(player_colors.values()[choosen_player_color])

	set_player_position(index)

	# Instance the player with the attached controller
	player_entities.add_child(player_instance)


func set_player_position(index : int) -> void:
		# Set the position of the player based on his id
		match index:
			0:
				player_instance.set_position(player_spawn_points.get_child(index).get_position())
			1:
				player_instance.set_position(player_spawn_points.get_child(index).get_position())
			2:
				player_instance.set_position(player_spawn_points.get_child(index).get_position())
			3:
				player_instance.set_position(player_spawn_points.get_child(index).get_position())

# -------------------- DECLARE FUNCTIONS --------------------

func define_player_amount() -> void:
	print("Defining player amount...")
	for index in range (0, 4):

		if GameConfig.player_list[GameConfig.player_list.keys()[index]]["is_created"] == true:
			player_amount += 1
			print("Player at index: ", index, " is created already! Player created counter: ", player_amount)
	print("Player amount is: ", player_amount)


func spawn_all_players() -> void:
	var current_players_spawn_counter = 1
	print("Spawning players...")
	for i in range (0, player_amount):
		print("Spawning player ", current_players_spawn_counter, " !")
		spawn_player(i)
		current_players_spawn_counter += 1
