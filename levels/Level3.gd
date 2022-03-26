extends Node2D


var door = preload("res://door/door.wav")
func _on_Plate_body_entered(body):
	if body.get_name() == "Crate":
		$Door.translate(Vector2('0','64'))
		$Door/AudioStreamPlayer2D.stream = door
		$Door/AudioStreamPlayer2D.play()
