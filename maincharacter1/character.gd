extends Sprite2D

@export var speed = 100.0
@export var jump_force = -200.0
@export var gravity = 500.0
@export var ground_level = 500.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var velocity = Vector2.ZERO
var is_jumping = false
var last_direction = 1 # 1 for right, -1 for left

func _ready():
	position.y = ground_level

func _physics_process(delta):
	# Horizontal Movement
	velocity.x = 0
	if Input.is_action_pressed("ui_left"):
		velocity.x = -speed
		animation_player.play("walk_left")
		last_direction = -1
	elif Input.is_action_pressed("ui_right"):
		velocity.x = speed
		animation_player.play("walk_right")
		last_direction = 1
	else:
		animation_player.play("idle")

	# Jumping Logic
	if is_jumping:
		# Apply gravity
		velocity.y += gravity * delta
		position.y += velocity.y * delta

		# Check if landed
		if position.y >= ground_level:
			position.y = ground_level
			velocity.y = 0
			is_jumping = false
			if last_direction == -1:
				animation_player.play("idle_left") # Optional: idle facing left
			else:
				animation_player.play("idle")
	else:
		# Apply gravity when not jumping (to settle on the ground)
		if position.y > ground_level:
			velocity.y += gravity * delta
			position.y += velocity.y * delta
			if position.y >= ground_level:
				position.y = ground_level
				velocity.y = 0
		elif Input.is_action_just_pressed("ui_accept") and _is_on_ground():
			is_jumping = true
			velocity.y = jump_force
			if last_direction == -1:
				animation_player.play("jump_left")
			else:
				animation_player.play("jump_right")

	position.x += velocity.x * delta

func _is_on_ground():
	return position.y >= ground_level
