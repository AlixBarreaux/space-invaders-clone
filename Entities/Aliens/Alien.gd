extends Area2D

class_name Alien

# -------------------- DECLARE VARIABLES --------------------

onready var kill_sound : AudioStreamPlayer2D = $KillSound
onready var animated_sprite : AnimatedSprite = $AnimatedSprite

export var points_added_to_score : int = 0
var next_frame : int = 0
var is_dead : bool = false

# --------------------  DECLARE SIGNALS  --------------------

# -------------------- DECLARE FUNCTIONS --------------------

# --------------------   RUN THE CODE    --------------------
func _ready() -> void:
	Events.connect("alien_group_moved", self, "play_animated_sprite_next_frame")

	if animated_sprite.frames != null:
		var animated_sprite_frame_resource_frame_count = animated_sprite.frames.get_frame_count("move")


# Sprite frames controls
func play_animated_sprite_next_frame() -> void:
	next_frame += 1
	if next_frame == 2:
		next_frame = 0
	animated_sprite.set_frame(next_frame)


# Set the animated sprite frame to the selected frame
func set_animated_sprite_current_frame(frame : int) -> void:
	animated_sprite.set_frame(frame)


# Reset the current animated sprite frame to the first one (0)
func reset_animated_sprite_frame() -> void:
	set_animated_sprite_current_frame(0)


# Collision hanlding
func disable_collisions() -> void:
	self.set_deferred("monitoring", false)
	self.set_deferred("monitorable", false)
	$CollisionShape2D.set_deferred("disabled", true)


func enable_collisions() -> void:
	self.set_deferred("monitoring", true)
	self.set_deferred("monitorable", true)
	$CollisionShape2D.set_deferred("disabled", false)


func _on_Alien_area_shape_entered(area_id, area, area_shape, self_shape):
	if area is BottomEdge:
		Events.emit_signal("game_over")
	else:
		# Disable collisions to let the player projectiles go through the now disabled alien
		die()
		# Play the death sound
		kill_sound.play()
		
		# Update the score GUI (SINGLETON!)
		Events.emit_signal("alien_killed", points_added_to_score)


func die() -> void:
	disable_collisions()
	self.hide()
	is_dead = true


func revive():
	self.show()
	enable_collisions()
	is_dead = false
