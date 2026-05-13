extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var marker_2d: Marker2D = $Marker2D

@export var ball_scene: PackedScene
@export var throw_strength: float = 500.0

const SPEED = 120.0
const JUMP_VELOCITY = -300.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("hit"):
		throw_ball() # Memanggil fungsi lempar yang kita buat tadi
	
	var direction := Input.get_axis("left", "right")
	
	if direction < 0:
		animated_sprite_2d.flip_h = true
	elif direction > 0:
		animated_sprite_2d.flip_h = false
	
	if direction:
		animated_sprite_2d.play("walk")
	else:
		animated_sprite_2d.play("idle")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()

func throw_ball():
	var ball = ball_scene.instantiate()
	get_tree().root.add_child(ball)
	ball.global_position = marker_2d.global_position
	
	var direction = (get_global_mouse_position() - global_position).normalized()
	
	var launch_velocity = (direction + Vector2(0, -0.3)).normalized() * throw_strength
	
	ball.apply_central_impulse(launch_velocity)
	ball.apply_torque_impulse(200.0)
