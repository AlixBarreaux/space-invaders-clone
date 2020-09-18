extends Node

# -------------------- DECLARE VARIABLES --------------------
var are_guests_inputs_enabled : bool = false
# Defines the is_player_slot_free values
var max_player_amount : int = 4

# Defines the availability of the player slots on the lobby screen. True = free
var is_player_slot_free : Array = [true]

# Key names to build the keys for the player_list dictionary
var player_list_key_names : PoolStringArray = ["player_one",
									"player_two",
									"player_three",
									"player_four"]

# ABSOLUTELY change player_ready_status to no value like so {} !!!
func check_if_players_ready() -> void:
	print(GameConfig.player_ready_status.values())
	if GameConfig.player_ready_status.values().has(true):
		print("Ready all!")
	else:
		print("Not ready all!")
# --------------------  DECLARE SIGNALS  --------------------


# -------------------- DECLARE FUNCTIONS --------------------

func define_free_devices_amounts():
		for duplicate in range (0, max_player_amount -1):
			is_player_slot_free.append(is_player_slot_free[0])


func get_all_guests_input() -> void:
	get_keyboard_arrows_input()
	get_joypad_zero_input()
	get_joypad_one_input()
	get_joypad_two_input()
	get_joypad_three_input()

# HOW TO ASSIGN A CONTROLLER OR KEYBOARD TO AN ID?
#var controller_ids : Array = [GameConfig.player_list.size()]

func get_keyboard_wasd_input() -> void:
		pass


var controller_alliases
var assigned_device_id
var assigned_device_id_two

var is_device_id_assigned : bool = false
var is_device_id_assigned_two : bool = false

var test : Dictionary = {"keyboard_wasd" :
									{"is_device_id_assigned" : false},
						"keyboard_arrows" :
									{"is_device_id_assigned" : false},
						"controller_zero" :
									{"is_device_id_assigned" : false},
						"controller_one" :
									{"is_device_id_assigned" : false}
						}


func get_keyboard_arrows_input() -> void:


	if Input.is_action_just_pressed("shoot_keyboard_arrow"):
		if test["keyboard_wasd"]["is_device_id_assigned"] == false:
			assigned_device_id = check_if_player_slot_free()
			is_device_id_assigned = true
			print("ASSIGNED DEVICE ID: ", assigned_device_id)
		else:
			print("The ID has been assigned already: ", is_device_id_assigned)

			print("I'm happy! ", GameConfig.player_list.keys()[assigned_device_id])
			controller_alliases = GameConfig.player_list.keys()[assigned_device_id]
			print("Controller alliases: ", controller_alliases)
#			print(GameConfig.player_stats)
#			print("TEST: ", GameConfig.player_list[0])
#			GameConfig.player_list[assigned_device_id]["is_player_ready"] = true
#			print("Ready state changed! New ready state: ", GameConfig.playerlist)

	if Input.is_action_just_pressed("move_up_keyboard_arrow") and is_device_id_assigned == true:
		print(is_player_slot_free)
		if is_player_slot_free[assigned_device_id] == false:
			print("Calling removal function!")
			remove_player(assigned_device_id)
			is_device_id_assigned = false
		else:
			print("Can't call removal function!")


func get_joypad_zero_input() -> void:
	if Input.is_action_just_pressed("shoot_joypad_zero"):
		print("Shooting on joypad zero!")
		if is_device_id_assigned_two == false:
			assigned_device_id_two = check_if_player_slot_free()
			is_device_id_assigned_two = true
			print("ASSIGNED DEVICE ID: ", assigned_device_id_two)
		else:
			print("The ID has been assigned already: ", is_device_id_assigned_two)

			print("I'm happy! ", GameConfig.player_list.keys()[assigned_device_id_two])
			controller_alliases = GameConfig.player_list.keys()[assigned_device_id_two]
			print("Contrller alliases: ", controller_alliases)
#			print("TEST: ", GameConfig.player_list[0])
#			GameConfig.player_list[assigned_device_id]["is_player_ready"] = true
#			print("Ready state changed! New ready state: ", GameConfig.playerlist)

	if Input.is_action_just_pressed("move_down_keyboard_arrow") and is_device_id_assigned_two == true:
		print(is_player_slot_free)
		if is_player_slot_free[assigned_device_id_two] == false:
			print("Calling removal function!")
			remove_player(assigned_device_id_two)
			is_device_id_assigned_two = false
		else:
			print("Can't call removal function!")



func get_joypad_one_input() -> void:
	pass


func get_joypad_two_input() -> void:
	pass


func get_joypad_three_input() -> void:
	pass




func check_if_player_slot_free():
	# Loop through all the player slots to check their availability
	var player_slot_index = -1

	# Check if the last slot is taken. Note: Since free slots are moved to the first free
	# slots on player removal, if the last slot in the array is taken (true), then there is
	# nore more room left.

	# Check first if the last slot is taken.
	if is_player_slot_free[is_player_slot_free.size() -1] == false:
		print("No player slot available at all!")
	# If there is at least one slot available
	else:
		for i in is_player_slot_free:

			player_slot_index += 1
			# If the player slot is free, CREATE THE PLAYER!!!!!!!!!!
			if i == true:
				print(player_slot_index, " is free: ", is_player_slot_free)
				create_player(player_slot_index)
				break
			# If the player slot is taken already, reiterate the loop
			else:
				print("Player slot ", player_slot_index, " is not available!")
	return player_slot_index


func create_player(id : int):
	print("Creating player...")

	print("GameConfig.player_list before change: ", GameConfig.player_list)
	print("Create player with index: ", id)

	is_player_slot_free[id] = false
	print("TEST create player: ", is_player_slot_free)

	var player_list_key_name = player_list_key_names[id]

	GameConfig.player_list[player_list_key_names[id]] = GameConfig.player_stats

	# id + 1 because we want the player id to start at 1 and not 0 by default
	GameConfig.player_list[player_list_key_names[id]]["player_id"] = id + 1
	GameConfig.player_list[player_list_key_names[id]]["is_player_ready"] = false
	GameConfig.player_list[player_list_key_names[id]]["player_name"] = str("Default Name ", id)
	# NEED TO SETUP LIVES IN PLAYER INSTANCE INSTEAD?
	GameConfig.player_list[player_list_key_names[id]]["player_lives"] = 2

	print("GameConfig.player_list after change: ", GameConfig.player_list)
	pass


func remove_player(player_allias):
#	dict.erase(dict.keys()[0])
	print("PLAYER ALLIAS: ", player_allias)
	print("Removing player! Player list before change: ", GameConfig.player_list)
	GameConfig.player_list.erase(GameConfig.player_list.keys()[player_allias])
	print("Player removed! Player list after change: ", GameConfig.player_list)
	is_player_slot_free[player_allias] = true
#	print("Removing player! Player list after change: ", GameConfig.player_list)

# --------------------   RUN THE CODE    --------------------

func _ready() -> void:
#	Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")
	are_guests_inputs_enabled = true

	define_free_devices_amounts()


func _physics_process(delta) -> void:
	if are_guests_inputs_enabled:
		get_all_guests_input()

#	print(Input.get_joy_axis(0, 0))

#func check_if_player_id_assigned(id : int):
#	if is_player_slot_free[id] == false:
#		check_if_player_created(id)
#
#
#func check_if_player_created(id):
#	print("Checking if player created...")
#	# Add the player to the player_ready_status dictionary
#	if is_player_slot_free[id] == false:
#		for i in range (1, 5):
#
#			if not is_player_slot_free:
#				if not GameConfig.player_list.has(player_list_key_names[i]):
#					print("LOOPING: ", i)
#					print("Game config player stats before creation: ", GameConfig.player_list)
#					assign_player_id(i)
#					is_player_slot_free[id] == true
#
#
#func create_player(id : int) -> void:
#	print("Creating player...")
#
#	var player_list_key_name = player_list_key_names[id]
#
#	GameConfig.player_list[player_list_key_names[id]] = GameConfig.player_stats
#
#	GameConfig.player_list[player_list_key_names[id]]["player_id"] = id
#	GameConfig.player_list[player_list_key_names[id]]["is_player_ready"] = false
#	GameConfig.player_list[player_list_key_names[id]]["player_name"] = str("Default Name ", id)
#	GameConfig.player_list[player_list_key_names[id]]["player_lives"] = 2
#
#
## Add values to whole dictionary player_list in GameConfig Autoload
#func assign_player_id(id : int) -> void:
#	print("Assigning player ID...")
#
#	match id:
#		1:
#			print("Device ID: ", id)
#			create_player(id)
#
#		2:
#			print("Device ID: ", id)
#			create_player(id)
#		3:
#			print("Device ID: ", id)
#			create_player(id)
#		4:
#			print("Device ID: ", id)
#			create_player(id)
#		_:
#			printerr("(!) ERROR: No Player assigned in MainMenu.gd!")
##	print("Player list in autoload: ", GameConfig.player_list)
#	print("Game config player stats after ID assignement: ", GameConfig.player_list)
#
#
#
#
## Setting ready / not ready state
#func get_joypad_zero_input() -> void:
#
#	if Input.is_action_just_pressed("shoot_joypad_zero"):
#
#
#		# PUT THIS IN A FUNCTION TO PUT THIS IN ALL THE GET_INPUT METHODS FOR BOTH CONTROLLER AND KEYBOARD!!!
#		# THE SINGLETON GameConfig MUST ALSO HAVE THE player_list Dictionary RESET TO {} WHEN EVERYTHING IS DONE!!
#			check_if_player_id_assigned(0)
#
#
#	if Input.is_action_just_pressed("shoot_arrow"):
#		pass
#
#
#
##		elif not GameConfig.player_list.has("player_two") and not is_player_created:
##			print("Hello Player 2! Creating player 2 state.")
##			print("Game config player stats before creation: ", GameConfig.player_list)
##
##			assign_player_id(2)
##			is_player_created = true
##
##		elif not GameConfig.player_list.has("player_three") and not is_player_created:
##			print("Hello Player 3! Creating player 3 state.")
##			print("Game config player stats before creation: ", GameConfig.player_list)
##
##			assign_player_id(3)
##			is_player_created = true
##
##		elif not GameConfig.player_list.has("player_four") and not is_player_created:
##			print("Hello Player 4! Creating player 4 state.")
##			print("Game config player stats before creation: ", GameConfig.player_list)
##
##			assign_player_id(4)
##			is_player_created = true
#
#		# WARNING! THE CODE BELOW DOESN'T HANDLE THE CASE FOR THE 4 PLAYERS, ONLY PLAYER 1 YET! CHANGE IT!
##		else:
##			if GameConfig.player_ready_status["player_one"] == false:
##				GameConfig.player_ready_status["player_one"] = true
##			else:
##				GameConfig.player_ready_status["player_one"] = false
##			print("Player ready status: ", GameConfig.player_ready_status["player_one"])
#
#	# TO INCLUDE CORRECTLY ABOVE!
#	# Leave the player slot and make it free with shoot button
##	if Input.is_action_just_pressed("shoot_joypad_zero"):
##		print("Starting timer!")
##		joypad_zero_timer.start()
##
##	if Input.is_action_just_released("shoot_joypad_zero") and joypad_zero_timer.get_time_left() >= 0:
##		print("Cancel! Time left: ", joypad_zero_timer.get_time_left())
##		joypad_zero_timer.stop()
#
#func _on_JoypadZeroTimer_timeout() -> void:
#	print("Ejecting!")
#
