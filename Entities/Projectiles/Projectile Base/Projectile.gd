extends Area2D

class_name Projectile

# -------------------- DECLARE VARIABLES --------------------
onready var sprite_frames = $SpriteFrames
onready var shoot_sound = $ShootSound

export var current_speed : int

#var vertical_move_direction : Dictionary = {"up" : -1, "down": 1}

var is_traveling : bool = false

var velocity : Vector2 = Vector2(0, 0)

var move_direction : int = -1
# --------------------  DECLARE SIGNALS  --------------------

# -------------------- DECLARE FUNCTIONS --------------------

#func define_move_direction(direction : String) -> void:
#	move_direction = vertical_move_direction[direction]
#	print(move_direction)

func start_moving() -> void:
	self.show()
	is_traveling = true
	shoot_sound.play()
	enable_collisions()


func stop_moving() -> void:
	disable_collisions()
	
	is_traveling = false
	self.hide()
#	reset_position(Vector2(0, 0))

func disable_collisions() -> void:
	self.set_deferred("monitoring", false)
	self.set_deferred("monitorable", false)
	$CollisionShape2D.set_deferred("disabled", true)
	set_physics_process(false)


func enable_collisions() -> void:
	self.set_deferred("monitoring", true)
	self.set_deferred("monitorable", true)
	$CollisionShape2D.set_deferred("disabled", false)
	set_physics_process(true)

#func reset_position(new_position : Vector2) -> void:
#	self.position = new_position
#	self.global_position = get_parent().get_child(2).global_position

# --------------------   RUN THE CODE    --------------------
func _ready() -> void:
	stop_moving()
	assert(current_speed > 0)
	assert(move_direction != 0)


#func _physics_process(delta : float) -> void:
#	self.global_position.y += move_direction * current_speed * delta


func _on_Projectile_body_entered(body : PhysicsBody2D):
	print("Something collided in projectile base area: ", body.name)
	self.stop_moving()
	is_traveling = false
	Events.emit_signal("projectile_alien_landed")
#	if body != Player:
#		self.get_parent().get_parent().increase_alien_projectiles_available_amount()
