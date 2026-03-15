extends CharacterBody2D


@export var speed = 300.0
var jump_velocity = -240.0
@export var push_force = 200
@export var pull_force = 150

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera: Camera2D = $Camera2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	# Handle size shifter
	if Input.is_action_just_pressed("grow"):
		if scale < Vector2(2, 2):
			camera.position.y += 5
			scale += Vector2(0.5, 0.5)
			speed -= 10
			jump_velocity += 20
	elif Input.is_action_just_pressed("shrink"):
		if scale > Vector2(1, 1):
			camera.position.y -= 5
			scale -= Vector2(0.5, 0.5)
			speed += 10
			jump_velocity -= 20

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	# Facing
	if direction < 0:
		animation.flip_h = true
	elif direction > 0:
		animation.flip_h = false
	
	# Animation
	if is_on_floor():
		if direction:
			animation.play("run")
		else:
			animation.play("idle")
	else:
		animation.play("jump") 
	
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		
		if collision.get_collider() is RigidBody2D:
			var body = collision.get_collider()
			body.apply_central_impulse(Vector2(direction * push_force, 0))
	
	if Input.is_action_pressed("pull"):
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)

			if collision.get_collider() is RigidBody2D:
				var body = collision.get_collider()
				
				var pull_dir = global_position.direction_to(body.global_position)
				body.apply_central_impulse(-pull_dir * pull_force)
