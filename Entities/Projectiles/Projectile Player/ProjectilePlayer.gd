extends Projectile

# -------------------- DECLARE VARIABLES --------------------

# --------------------  DECLARE SIGNALS  --------------------

# --------------------   RUN THE CODE    --------------------

func _ready() -> void:
	assert(shoot_sound.stream != null)

func _physics_process(delta : float) -> void:
	self.global_position.y += move_direction * current_speed * delta

# -------------------- DECLARE FUNCTIONS --------------------

func _on_ProjectilePlayer_area_shape_entered(area_id, area, area_shape, self_shape) -> void:
	print("Something entered projectile player: ", area.name)
	if area is Alien:
		print("Projectile player collided with: ", area.get_child(0))
	
	self.stop_moving()
