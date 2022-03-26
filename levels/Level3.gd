extends Node2D



func _on_Plate_body_entered(body):
	if body.get_name() == "Crate":
		$Door.translate(Vector2('0','64'))
