extends Node

class_name BottomEdge


func _on_BottomSideDetector_body_entered(body : PhysicsBody2D):
	print("Bottom Side Detector entered by: ", body.name)
