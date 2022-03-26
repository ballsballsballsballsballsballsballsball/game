extends KinematicBody2D

onready var animated_sprite : AnimatedSprite = $AnimatedSprite
onready var victory_text : RichTextLabel = $"Victory text"
onready var loss_text : RichTextLabel = $LossText
onready var explosion : Particles2D = $Explosion
var explosionSound = preload("res://explosion/explosion.wav")
var pushing = false

var diag = false

func _ready():
	if not OS.window_fullscreen:
		OS.window_fullscreen = true

func _physics_process(delta):
	if not victory_text.visible and not loss_text.visible:
		var movement_speed = 250.0
		var push_speed = 150.0
		if Input.is_action_pressed("ctrl"):
			movement_speed = 55.0
		var motion : = Vector2()
		motion.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		motion.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		
		# this took way too long wtf???
		if pushing and not motion.y:
			diag = false
		if pushing and motion.x and not diag:
			motion.y = 0
		if pushing and motion.y:
			diag = true
			motion.x = 0
			
		update_animation(motion)
		move_and_slide(motion.normalized() * movement_speed, Vector2())
		var slide_count = get_slide_count()
		if not slide_count:
			pushing = false
		for i in slide_count:
			var collision = get_slide_collision(i)
			if "Enemy" in collision.collider.name:
				loss()
			if "Crate" in collision.collider.name:
				pushing = true
				collision.collider.move_and_slide(motion.normalized() * push_speed, Vector2())
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
	if body.get_name() == "Player":
		victory(body)

func _on_Button_pressed():
	var currentscene = get_parent().name
	get_tree().change_scene("res://levels/Level" + str(int(currentscene[-1]) + 1) + '.tscn')


func victory(body):
	explosion.show()
	explosion.emitting = true
	$AudioStreamPlayer2D.stream = explosionSound
	$AudioStreamPlayer2D.play()
	animated_sprite.play('win')
	$"Victory text".show()
	var dir = Directory.new()
	var currentscene = get_parent().name
	var nextLvl = dir.file_exists("res://levels/Level" + str(int(currentscene[-1]) + 1) + '.tscn')
	if not nextLvl:
		var btn = $"Victory text/CenterContainer/Button"
		btn.connect("pressed", self, "_main_menu")
		btn.text = "Main Menu"

func _main_menu():
	get_tree().change_scene("res://MainMenu.tscn")

func loss():
	explosion.show()
	explosion.emitting = true
	$AudioStreamPlayer2D.stream = explosionSound
	$AudioStreamPlayer2D.play()
	animated_sprite.play('dead')
	$LossText.show()

func _on_RetryButton_pressed():
	get_tree().reload_current_scene()
