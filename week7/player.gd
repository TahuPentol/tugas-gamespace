extends CharacterBody2D

@export var speed: float = 120.0

var direction: Vector2
var external_speed_multiplier: float = 1.0

func _physics_process(delta: float) -> void:
	direction = Input.get_vector("left", "right", "up", "down")
	
	velocity = direction * speed * external_speed_multiplier
	
	move_and_slide()

func set_external_speed_multiplier(multiplier: float) -> void:
	external_speed_multiplier = max(multiplier, 0.0)
