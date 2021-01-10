extends Control

# -------------------- DECLARE VARIABLES --------------------

# Buttons

# Title screen buttons
onready var main_menu_buttons : VBoxContainer = $MainMenuButtons
onready var play_main_menu_button : Button = $MainMenuButtons/MainMenuPlay
onready var options_main_menu_button : Button =  $MainMenuButtons/Options
onready var quit_main_menu_button : Button = $MainMenuButtons/Quit
#onready var main_menu_button_list : Array = [play_main_menu_play_button, options_main_menu_play_button, quit_main_menu_play_button]

# Lobby buttons
onready var lobby : Control = $Lobby
onready var lobby_container : Control = $Lobby/LobbyContainer
onready var lobby_player_one : Button = $Lobby/LobbyContainer/PlayerOneButton
onready var lobby_launch_game_button : Button = $Lobby/LobbyContainer/LaunchGame

onready var lobby_back_to_menu : Button = $Lobby/LobbyContainer/LobbyBackToMenu

# Options Menu
onready var options_menu : Control = $OptionsMenu
onready var options_menu_back_to_menu : Button = $OptionsMenu/OptionsBackToMenu

# Remove Player Timers
onready var remove_player_timers : Node = $RemovePlayerTimers


onready var scene_manager = self.get_parent()

export var next_level : PackedScene

var are_guests_inputs_enabled : bool = false



# --------------------  DECLARE SIGNALS  --------------------

# --------------------   RUN THE CODE    --------------------

func _ready() -> void:
	disable_node(lobby_container)
	disable_node(options_menu)
	play_main_menu_button.grab_focus()


func _physics_process(_delta: float) -> void:
	if are_guests_inputs_enabled:
		get_guests_inputs()

# -------------------- DECLARE FUNCTIONS --------------------

func enable_node(node) -> void:
	node.set_physics_process(true)
	node.set_process(true)
	node.set_process_input(true)
	node.set_process_unhandled_input(false)


func disable_node(node) -> void:
	node.set_physics_process(false)
	node.set_process(false)
	node.set_process_input(false)
	node.set_process_unhandled_input(false)


func start_game() -> void:
	assert(scene_manager.name == "SceneManager")
	scene_manager.change_scene(next_level)


func toggle_guest_inputs():
	if not are_guests_inputs_enabled:
		are_guests_inputs_enabled = true
	else:
		are_guests_inputs_enabled = false


func get_guests_inputs() -> void:
	get_keyboard_arrows_inputs()
	get_joypad_zero_inputs()
	get_joypad_one_inputs()


func get_keyboard_arrows_inputs() -> void:
	if Input.is_action_just_pressed("shoot_keyboard_arrow"):
		check_if_player_created(2)
		remove_player_timers.get_child(0).start()


	if Input.is_action_just_released("shoot_keyboard_arrow"):
		remove_player_timers.get_child(0).stop()


func get_joypad_zero_inputs() -> void:
	if Input.is_action_just_pressed("shoot_joypad_zero"):
		check_if_player_created(3)
		remove_player_timers.get_child(1).start()


	if Input.is_action_just_released("shoot_joypad_zero"):
		remove_player_timers.get_child(1).stop()


func get_joypad_one_inputs() -> void:
	if Input.is_action_just_pressed("shoot_joypad_one"):
		check_if_player_created(4)
		remove_player_timers.get_child(2).start()


	if Input.is_action_just_released("shoot_joypad_one"):
		remove_player_timers.get_child(2).stop()


func _on_RemovePlayerTwoTimer_timeout():
	remove_player(2)


func _on_RemovePlayerThreeTimer_timeout():
	remove_player(3)


func _on_RemovePlayerFourTimer_timeout():
	remove_player(4)


#GameConfig.player_list.keys() returns ["player_one", "player_two",  "player_three"]
#so GameConfig.player_list.keys()[id] is used to find the key name
#and GameConfig.player_list[key] to access it


func check_if_player_one_ready() -> bool:
	if GameConfig.player_list[GameConfig.player_list.keys()[0]]["is_ready"] == true:
		return true
	else:
		return false


func check_if_all_players_ready() -> bool:

	var player_ready_counter : int = 0
	var player_created_counter : int = 0
	for index in range (0, 4):

		if GameConfig.player_list[GameConfig.player_list.keys()[index]]["is_created"] == true:
			player_created_counter += 1
			print("Player at index: ", index, " is created already! Player created counter: ", player_created_counter)
			# Check if ALL THE is_ready STATES ARE TRUE!
			if GameConfig.player_list[GameConfig.player_list.keys()[index]]["is_ready"] == true:
				player_ready_counter += 1
				print("Player ready at index:", index, " Counter: ", player_ready_counter)
			else:
				print("One of the player is not ready at index: ", index)
	print("FINAL COUNTER: ", player_ready_counter)

	if player_ready_counter == player_created_counter:
		print("Everyone is ready!")
		lobby_launch_game_button.show()
		return true
	else:
		print("One or more players are not ready!")
		lobby_launch_game_button.hide()
		return false

func check_if_player_created(id : int) -> void:

	if GameConfig.player_list[GameConfig.player_list.keys()[id - 1]]["is_created"] == false:
		create_player(id)
	else:
		print("DEBUG: Player created already!")
		toggle_player_ready_state(id)
		check_if_all_players_ready()


func create_player(id: int) -> void:
	id -= 1
	GameConfig.player_list[GameConfig.player_list.keys()[id]]["is_created"] = true
	print("Player ", id + 1, " created!")
	check_if_all_players_ready()


func remove_player(id: int) -> void:
	id -= 1
	GameConfig.player_list[GameConfig.player_list.keys()[id]]["is_created"] = false
	GameConfig.player_list[GameConfig.player_list.keys()[id]]["is_ready"] = false
	print("Player ", id + 1, " removed!")


func toggle_player_ready_state(id: int) -> void:
	id -= 1
	if not GameConfig.player_list[GameConfig.player_list.keys()[id]]["is_ready"]:
		print("Player ", id + 1, " State: Ready!")
		GameConfig.player_list[GameConfig.player_list.keys()[id]]["is_ready"] = true
	else:
		print("Player ", id + 1, " State: Not Ready!")
		GameConfig.player_list[GameConfig.player_list.keys()[id]]["is_ready"] = false
	check_if_all_players_ready()


func remove_all_guest_players() -> void:
	print("Removing all guest players...")
	for players in range (1, GameConfig.player_list.size()):
		remove_player(players)


func remove_all_players() -> void:
	print("Removing all playets: Player 1 and all guests will be deleted...")
	remove_player(0)
	remove_all_guest_players()


# Main Menu Buttons signals
func _on_MainMenuPlay_pressed() -> void:
	disable_node(main_menu_buttons)
	main_menu_buttons.hide()
	lobby.show()
	create_player(1)
	check_if_player_one_ready()
	enable_node(lobby_container)
	toggle_guest_inputs()


func _on_Options_pressed() -> void:
	disable_node(main_menu_buttons)
	main_menu_buttons.hide()
	enable_node(options_menu)
	$OptionsMenu/Change_Key_Bindings.disabled = true
	options_menu_back_to_menu.grab_focus()
	options_menu.show()


func _on_Quit_pressed() -> void:
	get_tree().quit()


func _on_PlayerOneButton_pressed():
	toggle_player_ready_state(1)


# Lobby Buttons Signals
func _on_LaunchGame_pressed() -> void:
	start_game()


func _on_BackToMenu_pressed() -> void:
	toggle_guest_inputs()
	disable_node(lobby_container)
	lobby.hide()
	main_menu_buttons.show()
	remove_all_players()
	enable_node(main_menu_buttons)
	if check_if_player_one_ready() == true:
		toggle_player_ready_state(0)


func _on_OptionsBackToMenu_pressed() -> void:
	disable_node(options_menu)
	options_menu.hide()
	main_menu_buttons.show()
	enable_node(main_menu_buttons)
	$MainMenuButtons/MainMenuPlay.grab_focus()
#func _input(event):
##	main_menu_button_list[0].grab_focus()
#
#	if Input.is_action_just_pressed("move_down_keyboard_wasd"):
#		cycle_downward(main_menu_button_list)
#	if Input.is_action_just_pressed("move_up_keyboard_wasd"):
#		cycle_upward(main_menu_button_list)
#	if Input.is_action_just_pressed("shoot_keyboard_wasd"):
#		print(event.as_text())
#
#var current_button_index = 0
#
#func grab_button_focus(button_list, index : int):
#	button_list[current_button_index].grab_focus()
#
#
#func cycle_upward(button_list) -> void:
#	current_button_index -= 1
#	if current_button_index < 0:
#		current_button_index = button_list.size() - 1
#	button_list[current_button_index].grab_focus()
#	print(current_button_index)
#
#
#func cycle_downward(button_list) -> void:
#	current_button_index += 1
#	if current_button_index == button_list.size():
#		current_button_index = 0
#	button_list[current_button_index].grab_focus()
#	print(current_button_index)

#		_on_MainMenuPlay_pressed()
#		accept_event()
