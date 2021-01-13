extends KinematicBody2D

class_name Player

"""
This is the main player class which is the 'turret' with its behaviors.
It requires the PlayerController scene, otherwise the player couldn't 
be controlled by any device.
"""

# -------------------- DECLARE VARIABLES --------------------
onready var cannon_muzzle : Position2D = $CannonMuzzle
onready var projectile : Area2D = $ProjectileContainer/ProjectilePlayer

# Collision related nodes
onready var hitbox = $Hitbox
onready var hitbox_collision_shape = $Hitbox/CollisionShape2D

onready var respawn_timer : Timer = $RespawnTimer

export var current_speed : int = 125

export var can_shoot : bool = false

var is_dead : bool = false
var can_revive : bool = true

var velocity : Vector2 = Vector2(0, 0)

# --------------------  DECLARE SIGNALS  --------------------

# -------------------- DECLARE FUNCTIONS --------------------

func _ready() -> void:
	Events.connect("wave_state_changed", self, "switch_shoot_mode")
	Events.connect("disable_player_reviving", self, "_on_disable_player_reviving")
	Events.connect("game_over", self, "_on_game_over")

func _on_disable_player_reviving() -> void:
	can_revive = false


func reset_projectile_position() -> void:
	projectile.set_global_position(cannon_muzzle.get_global_position())
	print("Projectile position reset: ", projectile.get_global_position())
	

# Defines if the player can shoot or not
func switch_shoot_mode() -> void:
	if can_shoot:
		can_shoot = false
	else:
		can_shoot = true



# Attach the player controller to the player
func instance_player_controller(instance : String):
	var player_controller_instance = load(instance).instance()
	self.add_child(player_controller_instance)
	print(self.name, " initialized!")


# Calculate the velocity with any MOVEMENT input
func calculate_velocity() -> void:
	velocity *= current_speed
	velocity = move_and_slide(velocity)


# Moves the players to the left (move_and_slide)
func move_left() -> void:
	velocity.x -= 1

# Moves the player to the right (move_and_slide)
func move_right() -> void:
	velocity.x += 1



#var projectile_preload_instance = preload("res://Entities/Projectiles/Projectile Base/Projectile.tscn").instance()

func shoot() -> void:
	if not projectile.is_traveling:
		can_shoot = true
		projectile.set_global_position(cannon_muzzle.get_global_position())
		projectile.start_moving()






func die() -> void:
	disable_projectiles_collisions()
	print("Player hurt!")
	is_dead = true
	can_shoot = false
	Events.emit_signal("player_died")
	if not can_revive:
		print("Holy shit! You're all dead for sure now!")
		Events.emit_signal("player_eliminated")


func revive() -> void:
	if can_revive:
		print("Reviving player!")
		enable_projectiles_collisions()
		is_dead = false
		can_shoot = true
	else:
		print("Nope, the player can't revive, no more life available!")


func disable_projectiles_collisions() -> void:

	hitbox.set_monitoring(false)
	hitbox.set_monitorable(false)
	hitbox_collision_shape.set_disabled(true)
	
	# Set play transparency to make kind of a ghost to move but still colliding with allies
	self.set_modulate("32ffffff")
	pass


func enable_projectiles_collisions() -> void:
	hitbox.set_monitoring(true)
	hitbox.set_monitorable(true)
	hitbox_collision_shape.set_disabled(false)
	# Set player transparency back to normal
	self.set_modulate("ffffff")


func _on_Hitbox_area_shape_entered(area_id: int, area: Area2D, area_shape, self_shape) -> void:
	if self.is_dead == false:
		# Disable the alien projectile
		if not area.name == "Hitbox":
			area.stop_moving()
			area.is_traveling = false
	
			# Make the player die and update the current_lives count
			self.die()
			respawn_timer.start()


func _on_RespawnTimer_timeout():
	revive()


func _on_game_over() -> void:
	self.queue_free()
