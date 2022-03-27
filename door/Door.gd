extends KinematicBody2D

var door = preload("res://door/door.wav")
func open():
	$AudioStreamPlayer2D.stream = door
	$AudioStreamPlayer2D.play()
	translate(Vector2(0, 64))
