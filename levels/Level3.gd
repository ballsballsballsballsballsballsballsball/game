extends Node2D

onready var open = false
func _on_Plate_body_entered(body):
	if not open:
		if body.get_name() == "Crate":
			open = true
			$Door.open()
