extends KinematicBody2D

onready var animated_sprite : AnimatedSprite = $AnimatedSprite
onready var victory_text : RichTextLabel = $"Victory text"
onready var loss_text : RichTextLabel = $LossText
onready var explosion : Particles2D = $Explosion
var explosionSound = preload("res://explosion/explosion.wav")

export var movement_speed = 250.0

func _physics_process(delta):
	if not victory_text.visible and not loss_text.visible:
		var motion : = Vector2()
		motion.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		motion.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		
		update_animation(motion)
		move_and_slide(motion.normalized() * movement_speed, Vector2())
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			if collision.collider.name == "Enemy":
				loss()
	
func update_animation(motion: Vector2):
	var animation = 'idle'
	if motion.x > 0:
		animation = 'right'
	elif motion.x < 0:
		animation = 'left'
	elif motion.y < 0:
		animation = 'up'
	elif motion.y > 0:
		animation = 'down'
		
	if animated_sprite.animation != animation:
		animated_sprite.play(animation)


func _on_Goal_body_entered(body):
	victory(body)

func _on_Button_pressed():
	var currentscene = get_parent().name
	get_tree().change_scene("res://levels/Level" + str(int(currentscene[-1]) + 1) + '.tscn')


func victory(body):
	explosion.show()
	explosion.emitting = true
	$AudioStreamPlayer2D.stream = explosionSound
	$AudioStreamPlayer2D.play()
	animated_sprite.play('idle')
	$"Victory text".show()
	var dir = Directory.new()
	var currentscene = get_parent().name
	var nextLvl = dir.file_exists("res://levels/Level" + str(int(currentscene[-1]) + 1) + '.tscn')
	if not nextLvl:
		var btn = $"Victory text/CenterContainer/Button"
		btn.disabled = true
		btn.text = "THERE IS NO NEXT LEVEL!?!?!?"


func loss():
	explosion.show()
	explosion.emitting = true
	$AudioStreamPlayer2D.stream = explosionSound
	$AudioStreamPlayer2D.play()
	animated_sprite.play('idle')
	$LossText.show()

func _on_RetryButton_pressed():
	get_tree().reload_current_scene()
