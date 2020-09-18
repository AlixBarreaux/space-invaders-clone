extends Projectile

class_name ProjectileAlien

"""
The base alien projectile. It has several projectile skins, so different animated sprite frames will be used
for the projectile and it'll choose a random skin each time it's about to be launched.
Each time a projectile skin must be added here, create a const with the spriteframesresource path and then add
it to the projectile_skins_list Array. Finally, add a value to the enum PROJECTILE_SKINS.
It'll work automatically.
"""

# -------------------- DECLARE VARIABLES --------------------
const JESUS_CROSS_SPRITE_FRAMES_PATH = "res://Entities/Projectiles/Projectiles Aliens/Jesus Cross/projectile_alien_jesus_cross_sprite_frames_resource.tres"
const THUNDER_SPRITE_FRAMES_PATH = "res://Entities/Projectiles/Projectiles Aliens/Thunder/thunder_sprite_frames_resource.tres"

enum PROJECTILE_SKINS {JESUS_CROSS = 0, THUNDER = 1}
export (PROJECTILE_SKINS) var current_projectile_skin

var projectile_skins_list : Array = [preload(JESUS_CROSS_SPRITE_FRAMES_PATH), preload(THUNDER_SPRITE_FRAMES_PATH)]
var projectile_skins_list_length : int

var random_number_generator = RandomNumberGenerator.new()
var current_projectile_index : int
var current_projectile

# --------------------  DECLARE SIGNALS  --------------------

# --------------------   RUN THE CODE    --------------------


func _physics_process(delta : float) -> void:
	self.global_position.y -= move_direction * current_speed * delta

# -------------------- DECLARE FUNCTIONS --------------------
func build_projectile_skins_list() -> void:
	projectile_skins_list_length = projectile_skins_list.size() - 1
#	print("Building projectile skins list in ProjectileAlien...")



func choose_random_projectile_skin() -> void:
	random_number_generator.randomize()
	current_projectile_index = random_number_generator.randi_range(0, projectile_skins_list_length)
	current_projectile = projectile_skins_list[current_projectile_index]
#	print("Random projectile skin chosen! :", current_projectile)
	
	apply_projectile_skin()


func apply_projectile_skin() -> void:
	sprite_frames.set_sprite_frames(current_projectile)
#	print("Sprite frames resource: ", sprite_frames.get_sprite_frames())


func start_moving() -> void:
	build_projectile_skins_list()
	choose_random_projectile_skin()
	self.show()
	is_traveling = true
	shoot_sound.play()
	enable_collisions()
	


func _on_ProjectileAlien_area_shape_entered(area_id, area, area_shape, self_shape) -> void:
	print("Something entered projectile alien: ", area.name)
	if area is Player:
		print("Projectile alien collided with a player! Get child 0 :", area.get_child(0))
	
#	self.stop_moving()
