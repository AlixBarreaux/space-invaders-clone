extends EdgeDetector

# -------------------- DECLARE VARIABLES --------------------

# --------------------  DECLARE SIGNALS  --------------------

# --------------------   RUN THE CODE    --------------------

# -------------------- DECLARE FUNCTIONS --------------------

func _on_EdgeDetectorLeft_area_shape_exited(area_id, area, area_shape, self_shape):
	# Left edge exited:
	Events.emit_signal("alien_group_exited_side_edge", edges.values()[1])
