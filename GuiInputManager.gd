extends Node

"""
The GUI Input Manager is a script that must be attached to a control node (or 
at least containing some GUI nodes). It puts all its children node(s) in the 
button_list array (localy) to then be able to enable to cycle through the 
children buttons of the node the script is attached to.
"""
# -------------------- DECLARE VARIABLES --------------------
var current_button_index : int = 0
var button_list : Array = []
# --------------------  DECLARE SIGNALS  --------------------

# --------------------   RUN THE CODE    --------------------

func _ready() -> void:
	initialize_button_list()

func _input(event) -> void:
#	main_menu_button_list[0].grab_focus()

	if Input.is_action_just_pressed("move_down_keyboard_wasd"):
		cycle_downward()
	if Input.is_action_just_pressed("move_up_keyboard_wasd"):
		cycle_upward()
	if Input.is_action_just_pressed("shoot_keyboard_wasd"):
		press_button()

# -------------------- DECLARE FUNCTIONS --------------------

# Populate the button list array with the button nodes, whatever the number of different 
# nodes and their type. The array is used to build a list to cycle through
func initialize_button_list() -> void:
	for children in self.get_children():
		if children is Button:
			button_list.append(children)


# Grab the button focus
func grab_button_focus() -> void:
	button_list[current_button_index].grab_focus()


func grab_button_focus_on_index(button_id_in_list : int) -> void:
#	button_list[button_id_in_list].set_is_hovered(true)
	button_list[button_id_in_list].grab_focus()


# Move the button selection (focus) up in the GUI
func cycle_upward() -> void:
	current_button_index -= 1
	if current_button_index < 0:
		current_button_index = button_list.size() - 1
	check_if_button_available(false)
	grab_button_focus()
	print(self.name, " ", current_button_index)


# Move the button selection (focus) down in the GUI
func cycle_downward() -> void:
	current_button_index += 1
	if current_button_index == button_list.size():
		current_button_index = 0
	check_if_button_available(true)
	grab_button_focus()
	print(self.name, " ", current_button_index)


# Check if the button is hidden (or disabled in comment) to ignore him and go the next button
func check_if_button_available(is_index_positive : bool) -> void:
	if button_list[current_button_index].visible == false:
#		 || button_list[current_button_index].is_toggle_mode() == false
		if is_index_positive:
			current_button_index += 1
		else:
			current_button_index -= 1


# Press the button
func press_button() -> void:
	button_list[current_button_index].emit_signal("pressed")
	pass
