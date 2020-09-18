extends Area2D

class_name EdgeDetector

# -------------------- DECLARE VARIABLES --------------------

var edges : Dictionary = {"left" : 0, "right": 1, "bottom" : 2}

# --------------------  DECLARE SIGNALS  --------------------

# --------------------   RUN THE CODE    --------------------

# -------------------- DECLARE FUNCTIONS --------------------


func _on_EdgeDetectorLeft_area_shape_exited(area_id, area, area_shape, self_shape):
	print("Side edge exited by: ", area.name)
