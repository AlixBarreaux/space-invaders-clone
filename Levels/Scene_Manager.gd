extends Node

# -------------------- DECLARE VARIABLES --------------------
export var game_gui : PackedScene
export var main_menu : PackedScene
export var score_gui : PackedScene

var current_scene_load
var current_scene_instance
# --------------------  DECLARE SIGNALS  --------------------

# --------------------   RUN THE CODE    --------------------
func _ready() -> void:
#	Events.connect("game_over", self, "change_scene", [score_gui])
	pass


# -------------------- DECLARE FUNCTIONS --------------------

func choose_scene(scene_name : String) -> void:
	match scene_name:
		"game_gui":
			change_scene(game_gui)
		"main_menu":
			change_scene(main_menu)
		"score_gui":
			change_scene(score_gui)
		_:
			printerr("(!) ERROR in Scene_Manager: The selected scene doesn't match any from this script!")


func change_scene(scene):
	remove_scene()
	
	# Add another scene and instance it
	# Load the scene
	current_scene_load = scene
#	print("Scene: ", current_scene_load, " successfully loaded in memory!")
	
	# Instance the loaded scene
	current_scene_instance = current_scene_load.instance()
	
	# Add the instanced scene to the scene tree
	call_deferred("add_scene_to_scene_tree")


func remove_scene():
	# Remove the current scene
	print("Removing scene: ", self.get_child(0).name)
	self.get_child(0).queue_free()


func add_scene_to_scene_tree():
	self.add_child(current_scene_instance)
