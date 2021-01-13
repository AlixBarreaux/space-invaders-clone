extends Node


func _physics_process(_delta : float) -> void:
	if Input.is_action_pressed("leave_game"):
		get_tree().quit()
