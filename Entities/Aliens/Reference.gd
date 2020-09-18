extends Node2D

# -------------------- DECLARE VARIABLES --------------------
#onready var alien_group : Node2D = $AlienGroup
#onready var info_label_horizontal : Label = $InfoLabelHorizontal
#onready var info_label_vertical : Label = $InfoLabelVertical

#export var vertical_spacing : int = 3
#
#var total_horizontal_spacing : int = 0
#var horizontal_counter : int = 0
#
#export var total_vertical_spacing : int = 18
#var vertical_counter : int = 0

# --------------------  DECLARE SIGNALS  --------------------

# -------------------- DECLARE FUNCTIONS --------------------

# --------------------   RUN THE CODE    --------------------
func _ready() -> void:
#	info_label.text = str("Total spacing: ", total_horizontal_spacing, " \nhorizontal_counter: ", horizontal_counter)
#	for i in range(0, 41):
#		alien_group.position.x += vertical_spacing
#		total_horizontal_spacing += vertical_spacing
#		horizontal_counter += 1
#		info_label.text = str("Total spacing: ", total_horizontal_spacing, " \nhorizontal_counter: ", horizontal_counter)
	pass

#func _physics_process(delta : float) -> void:
#	if Input.is_action_just_pressed("move_right_keyboard_arrow"):
#		alien_group.position.x += vertical_spacing
#		total_horizontal_spacing += vertical_spacing
#		horizontal_counter += 1
#		info_label_horizontal.text = str("Total spacing: ", total_horizontal_spacing, " \nHorizontal_counter: ", horizontal_counter)
#
#	if Input.is_action_just_pressed("move_left_keyboard_arrow"):
#		alien_group.position.x -= vertical_spacing
#		total_horizontal_spacing -= vertical_spacing
#		horizontal_counter -= 1
#		info_label_horizontal.text = str("Total spacing: ", total_horizontal_spacing, " \nHorizontal_counter: ", horizontal_counter)
#
#	if Input.is_action_just_pressed("move_down_keyboard_arrow"):
#		alien_group.position.y += 18
#		total_vertical_spacing += vertical_spacing
#		vertical_counter += 1
#		info_label_vertical.text = str("Total spacing: ", total_vertical_spacing, " \nVorizontal_counter: ", vertical_counter)
#
#	if Input.is_action_just_pressed("move_up_keyboard_arrow"):
#		alien_group.position.y -= 18
#		total_vertical_spacing -= vertical_spacing
#		vertical_counter -= 1
#		info_label_vertical.text = str("Total spacing: ", total_vertical_spacing, " \nVertical_counter: ", vertical_counter)
