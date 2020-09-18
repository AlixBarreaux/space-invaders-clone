extends Area2D

class_name AlienGroup
# -------------------- DECLARE VARIABLES --------------------

onready var lines = $Lines
onready var move_sound_playlist : Node = $MoveSoundPlaylist
onready var move_cooldown_timer = $MoveCoolDownTimer

# Alien projectiles container (contains all the projectiles)
onready var alien_projectiles_container : Node = $AlienProjectilesContainer

# Alien projectiles timers
onready var spawn_projectile_timers = $SpawnProjectileTimers

onready var spawn_projectile_timer_one : Timer = $SpawnProjectileTimers/SpawnProjectileTimer
onready var spawn_projectile_timer_two : Timer = $SpawnProjectileTimers/SpawnProjectileTimer2
onready var spawn_projectile_timer_three : Timer = $SpawnProjectileTimers/SpawnProjectileTimer3
onready var spawn_projectile_timer_four : Timer = $SpawnProjectileTimers/SpawnProjectileTimer4


enum MOVE_DIRECTION {LEFT = 0, RIGHT = 1}
export (MOVE_DIRECTION) var move_direction = MOVE_DIRECTION.LEFT
export var horizontal_spacing : int = 3
export var vertical_spacing : int = 18

# Tracks the number of aliens dead, alive, and their total
var total_alien_amount : int = 55
var alive_alien_amount : int = total_alien_amount
var dead_alien_amount : int = 0

var levels_moved_down : int = 0
export var timer_speed_factor : float = 0.7
var wave_cleared_counter : int = 0

# Random projectile alien spawn location variables
var alien_amount_per_line : int = 11
var alien_lines_amount : int = 5

var random_line_number_generator = RandomNumberGenerator.new()
var random_alien_slot_number_generator = RandomNumberGenerator.new()

var selected_alien_line_number : int
var selected_alien_slot_number : int

var selected_alien_line
var selected_alien_slot

# --------------------  DECLARE SIGNALS  --------------------

# --------------------   RUN THE CODE    --------------------

func _ready() -> void:
	# Initialize all signals
	Events.connect("alien_group_exited_side_edge", self, "on_edge_exited")
	Events.connect("alien_killed", self, "update_alien_amount")
	Events.connect("projectile_alien_landed", self, "increase_alien_projectiles_available_amount")
	Events.connect("game_over", self, "on_game_over")
	
	
	# Randomize the random number generator for picking a random alien spot
	# to spawn the projectile to its location
	random_line_number_generator.randomize()
	random_alien_slot_number_generator.randomize()
	
	
	# The alien wave starts hidden and disabled but is present
	kill_alien_wave()
	
	# Get ready time and then spawn the alien group
	yield(get_tree().create_timer(2), "timeout")
	self.show()
	yield(get_tree().create_timer(0.5), "timeout")
	spawn_new_alien_wave()
	Events.emit_signal("wave_state_changed")
	
	
	
	
	build_alien_projectiles_skins_lists()
	
	yield(get_tree().create_timer(0.5), "timeout")
	start_spawn_projectile_timers()

var spawn_projectile_timer_wait_time : float = 0
var spawn_projectile_timer_wait_time_random_number_generator = RandomNumberGenerator.new()

export var min_spawn_projectile_timer_wait_time : float = 5
export var max_spawn_projectile_timer_wait_time : float = 8
# Set a random time for shooting alien projectiles for the SpawnProjectileTimer
func set_spawn_projectile_timer_randomized_wait_time(timer : Timer) -> void:
	spawn_projectile_timer_wait_time = spawn_projectile_timer_wait_time_random_number_generator.randf_range(min_spawn_projectile_timer_wait_time, max_spawn_projectile_timer_wait_time)
	# Round to 2 digits number
	spawn_projectile_timer_wait_time = stepify(spawn_projectile_timer_wait_time, 0.01)
	timer.set_wait_time(spawn_projectile_timer_wait_time)


func start_spawn_projectile_timers() -> void:
	for timer in spawn_projectile_timers.get_children():
		timer.start()


func _on_SpawnProjectileTimer_timeout() -> void:
	spawn_projectile_timer_one.stop()
	set_spawn_projectile_timer_randomized_wait_time(spawn_projectile_timer_one)
	spawn_projectile_timer_one.start()
	spawn_alien_projectile_at_random_alien_location()


func _on_SpawnProjectileTimer2_timeout() -> void:
	spawn_projectile_timer_two.stop()
	set_spawn_projectile_timer_randomized_wait_time(spawn_projectile_timer_two)
	spawn_projectile_timer_two.start()
	spawn_alien_projectile_at_random_alien_location()


func _on_SpawnProjectileTimer3_timeout() -> void:
	spawn_projectile_timer_three.stop()
	set_spawn_projectile_timer_randomized_wait_time(spawn_projectile_timer_three)
	spawn_projectile_timer_three.start()
	spawn_alien_projectile_at_random_alien_location()


func _on_SpawnProjectileTimer4_timeout() -> void:
	spawn_projectile_timer_four.stop()
	set_spawn_projectile_timer_randomized_wait_time(spawn_projectile_timer_four)
	spawn_projectile_timer_four.start()
	spawn_alien_projectile_at_random_alien_location()


var max_alien_projectiles_available_amount : int = 4
var alien_projectiles_available_amount : int = max_alien_projectiles_available_amount


func build_alien_projectiles_skins_lists() -> void:
	for alien_projectiles in alien_projectiles_container.get_children():
		alien_projectiles.build_projectile_skins_list()

func spawn_alien_projectile_at_random_alien_location() -> void:
	selected_alien_line_number = random_line_number_generator.randi_range(0, alien_lines_amount - 1)
	selected_alien_slot_number = random_alien_slot_number_generator.randi_range(0, alien_amount_per_line - 1)
	
	selected_alien_line = lines.get_child(selected_alien_line_number)

	selected_alien_slot = selected_alien_line.get_child(selected_alien_slot_number)
	
	if selected_alien_slot.get_child(0).is_dead == true:
		spawn_alien_projectile_at_random_alien_location()
	else:
#		print("The alien projectile will spawn in line: ", selected_alien_line.name, " in the slot: ", selected_alien_slot.name)
		
		# Shoot a projectile at a random location
		check_alien_projectiles_available_amount()



func decrease_alien_projectiles_available_amount() -> void:
	alien_projectiles_available_amount -= 1

func increase_alien_projectiles_available_amount() -> void:
	alien_projectiles_available_amount += 1

func check_alien_projectiles_available_amount() -> void:
	if alien_projectiles_available_amount > 0:
		print("A projectile is available to be shot!")
		for projectile in alien_projectiles_container.get_children():
			if projectile.is_traveling == false:
				print(projectile.name, " is not traveling, available for launch!")
				shoot_alien_projectile(projectile)
				break
	else:
		print("No alien projectile available to be shot!")

func shoot_alien_projectile(projectile) -> void:
	decrease_alien_projectiles_available_amount()
	projectile.set_global_position(selected_alien_slot.get_global_position())
	projectile.start_moving()
	projectile.choose_random_projectile_skin()

# -------------------- DECLARE FUNCTIONS --------------------

# MOVEMENTS

func move_left() -> void:
	self.position.x -= horizontal_spacing
	Events.emit_signal("alien_group_moved")


func move_right() -> void:
	self.position.x += horizontal_spacing
	Events.emit_signal("alien_group_moved")


func move_up() -> void:
	self.position.y -= vertical_spacing
	decrease_levels_moved_down_counter(1)


func move_down() -> void:
	self.position.y += vertical_spacing
	increase_levels_moved_down_counter(1)


func switch_x_axis_direction() -> void:
	if move_direction == MOVE_DIRECTION.LEFT:
		move_direction = MOVE_DIRECTION.RIGHT
	else:
		move_direction = MOVE_DIRECTION.LEFT


func on_edge_exited(edge : int) -> void:
	match edge:
		0:
#			print("Exiting left area!")
			switch_x_axis_direction()
			move_down()			
			accelerate_alien_group_speed()

		1:
#			print("Exiting right area!")
			switch_x_axis_direction()
			move_down()
			accelerate_alien_group_speed()

		_:
			printerr("An error occured with the index of the edge\ndetector in Alien group!\nPlease check the SideEdgeDetector Scene")


###########################################################################################

func reset_wave_cleared_counter() -> void:
	wave_cleared_counter = 0


func increase_wave_cleared_counter(value : int) -> void:
	wave_cleared_counter += value
#	print("Wave cleared counter increased! New value: ", wave_cleared_counter)

var current_line_number : int = 1
func check_wave_cleared_count() -> void:
#	print("Checking wave count...")
	match wave_cleared_counter:
		0:
#			print("No wave has been cleared according to the wave counter! : ", wave_cleared_counter)
			reset_aliens_position(Vector2(0, vertical_spacing))
		1:
#			print(wave_cleared_counter, " wave has been cleared according to the wave counter!")
			reset_aliens_position(Vector2(0, vertical_spacing * current_line_number))
		2:
#			print(wave_cleared_counter, " wave has been cleared according to the wave counter!")
			reset_aliens_position(Vector2(0, vertical_spacing * current_line_number))
		3:
#			print(wave_cleared_counter, " wave has been cleared according to the wave counter!")
			reset_aliens_position(Vector2(0, vertical_spacing * current_line_number))
		_:
#			print("Clamping to 3 lines for aliens position!")
			# Optional line of code just below just so that the current_line number doesn't go up
			# For memory's sake
			current_line_number = 4
#			print(wave_cleared_counter, " wave has been cleared according to the wave counter!")
			reset_aliens_position(Vector2(0, vertical_spacing * current_line_number))


func accelerate_alien_group_speed() -> void:
#	print("Acceleratin alien group speed!")
	var new_speed = move_cooldown_timer.get_wait_time() * timer_speed_factor
	if new_speed < 0.04:
		new_speed = 0.02
	else:
		stepify(new_speed, 0.1)
		move_cooldown_timer.set_wait_time(new_speed)


func reset_alien_group_speed() -> void:
#	print("Resetting alien group speed!")
	move_cooldown_timer.set_wait_time(0.5)
#	for i in range (0, levels_moved_down):
#		accelerate_alien_group_speed() 


func set_levels_moved_down_counter(value : int) -> void:
	levels_moved_down = value


func decrease_levels_moved_down_counter(value : int) -> void:
	levels_moved_down -= 1


func increase_levels_moved_down_counter(value : int) -> void:
	levels_moved_down += value
#	print("Levels moved down: ", levels_moved_down)


func reset_levels_moved_down_counter() -> void:
#	print("Resetting the levels moved down counter!")
	levels_moved_down = 0


func place_aliens_to_level(level : int):
	self.position.y += vertical_spacing * level


onready var start_position : Vector2 = self.get_global_position()

func reset_aliens_position(new_position : Vector2) -> void:
	self.global_position = start_position + new_position
###########################################################################################


func _on_MoveCoolDownTimer_timeout() -> void:
	if move_direction == MOVE_DIRECTION.LEFT:
		move_left()
	else:
		move_right()
	
	
	var alien_projectile_load = load("res://Entities/Projectiles/Projectiles Aliens/ProjectileAlien.tscn")
	# Random alien shooting
	var alien_projectile_instance = alien_projectile_load.instance()

	alien_projectile_instance.position = $Lines/Line2/Slot11/Crab.get_position()
	
	add_child(alien_projectile_instance)
	move_sound_playlist.play_next_track_from_playlist()


# Update the alien amount (displayed in the ScoreGUI scene)
func update_alien_amount(score : int) -> void:
	alive_alien_amount -= 1
	dead_alien_amount += 1
#	print("Alive: ", alive_alien_amount, " Dead: ", dead_alien_amount)
	check_if_all_aliens_dead()


# Check if all the aliens are dead and emit the "wave_cleared" signal
func check_if_all_aliens_dead() -> void:
	if dead_alien_amount == total_alien_amount:
#		print("Wave cleared!")
		Events.emit_signal("wave_cleared")
		current_line_number += 1
		increase_wave_cleared_counter(1)
		spawn_new_alien_wave()


# Spawn a new alien wave and reset the group position,
# the play sound, and each alien's sprite frame individually
func spawn_new_alien_wave() -> void:
#	print("Spawning new alien wave!")
	# Disable the alien group's movements
	move_cooldown_timer.stop()
	
	# Revive all the aliens contained in all the lines
	# Also reset thei animated sprite frame to the beginning
	# of the move animation
	for line in lines.get_children():
		for alien_slot in line.get_children():
			var slot = alien_slot.get_child(0)
			slot.revive()
			slot.reset_animated_sprite_frame()
			move_sound_playlist.reset_playlist_track_from_playlist_to_first()
	
	# Reset the alive and dead amount so that the score and
	# wave GUI are updated correctly
	alive_alien_amount = total_alien_amount
	dead_alien_amount = 0
	

	
	# Set the line it should spawn in
	# Also set a limit of lines to move down so that
	# The aliens do not spawn too close from the limit
	
#	if levels_moved_down > 3:
#		levels_moved_down = 3
	
	# Reset the alien group position depending on the wave count
	check_wave_cleared_count()
	
	# Reset the alien group speed 
	reset_alien_group_speed()
	
	# Re-Enable the alien group's movements
	move_cooldown_timer.start()


# When the game is over
func on_game_over() -> void:
	# Stop the aliens from moving and earape the player(s)
	self.queue_free()


func kill_alien_wave() -> void:
#	print("Killing the whole alien wave!")
	move_cooldown_timer.stop()
	for line in lines.get_children():
		for alien_slot in line.get_children():
			var slot = alien_slot.get_child(0)
			slot.die()
