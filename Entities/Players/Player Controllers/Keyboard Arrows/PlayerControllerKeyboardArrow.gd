extends Node

# -------------------- DECLARE VARIABLES --------------------

# --------------------  DECLARE SIGNALS  --------------------

# -------------------- DECLARE FUNCTIONS --------------------

# --------------------   RUN THE CODE    --------------------
func _ready() -> void:
	assert("Player" in self.get_parent().name)
	pass

func _physics_process(delta : float) -> void:
	self.get_parent().velocity = Vector2(0, 0)
	
	if Input.is_action_pressed("shoot_keyboard_arrow"):
		if self.get_parent().can_shoot:
			self.get_parent().shoot()
	if Input.get_action_strength("move_left_keyboard_arrow"):
		self.get_parent().move_left()
	if Input.get_action_strength("move_right_keyboard_arrow"):
		self.get_parent().move_right()
	
	self.get_parent().calculate_velocity()
