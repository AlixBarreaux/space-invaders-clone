extends Node

# -------------------- DECLARE VARIABLES --------------------
var player_list : Dictionary = {"player_one" : {
												"is_created" : false,
												"is_ready" : false
												},
								"player_two" : {
												"is_created" : false,
												"is_ready" : false
												},
								"player_three" : {
												"is_created" : false,
												"is_ready" : false
												},
								"player_four" : {
												"is_created" : false,
												"is_ready" : false
												}
								}


var are_all_players_ready : bool = false

# --------------------  DECLARE SIGNALS  --------------------

# -------------------- DECLARE FUNCTIONS --------------------
#func check_joycon_connection():
#	Input.connect("joy_connection_changed", self, "on_joycon_changed")
#	print("Connected joypad(s): " + str(Input.get_connected_joypads()))
#	print("NAME: ", Input.get_joy_name(0))
# --------------------   RUN THE CODE    --------------------
func _ready() -> void:
#	check_joycon_connection()
	pass
