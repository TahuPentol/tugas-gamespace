extends CharacterBody2D

@export var speed: float = 120.0

var direction: Vector2

func _physics_process(delta: float) -> void:
	direction = Input.get_vector("left", "right", "up", "down")
	
	velocity = direction * speed
	
	move_and_slide()
