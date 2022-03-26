extends Node2D



func _on_Area2D_body_entered(body):
	if body.get_name() == 'Player':
		$WindowDialog.popup_centered()
		get_node("Area2D/CollisionShape2D").disabled = true
