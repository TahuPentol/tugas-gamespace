extends CharacterBody2D


@export var speed = 300.0
var jump_velocity = -240.0
@export var push_force = 200
@export var pull_force = 150
@export var dynamite_scene: PackedScene
@export var throw_strength: float = 500.0

@onready var marker_2d: Marker2D = $Marker2D
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
	
	if Input.is_action_just_pressed("throw_dynamite"):
		throw_grenade() # Memanggil fungsi lempar yang kita buat tadi
	
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
	
	get_local_mouse_position()
	
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

func throw_grenade():
	var dynamite = dynamite_scene.instantiate()
	get_tree().root.add_child(dynamite)
	dynamite.global_position = marker_2d.global_position
	
	# Ambil arah dari player ke posisi mouse
	var direction = (get_global_mouse_position() - global_position).normalized()
	
	# Berikan sedikit lengkungan ke atas (Arc) secara otomatis 
	# dengan menambahkan Vector2.UP sedikit ke arah lemparan
	var launch_velocity = (direction + Vector2(0, -0.3)).normalized() * throw_strength
	
	dynamite.apply_central_impulse(launch_velocity)
	# Tambahkan sedikit rotasi (torque) agar granat berputar saat melayang
	dynamite.apply_torque_impulse(200.0)
