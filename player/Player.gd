extends KinematicBody2D

onready var animated_sprite : AnimatedSprite = $AnimatedSprite

export var movement_speed = 250.0

func _physics_process(delta):
	var motion : = Vector2()
	motion.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	motion.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	update_animation(motion)
	move_and_slide(motion.normalized() * movement_speed, Vector2())
	
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
