class_name WeaponComponent
extends Node2D

@export var stats: WeaponStats
@export var lerp_speed: float = 15.0
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hitbox: HitboxComponent = $WeaponPivot/Hitbox

var target_rotation: float = 0.0
var can_attack: bool = true
var cooldown_timer: Timer

func _ready() -> void:
	cooldown_timer = Timer.new()
	add_child(cooldown_timer)
	cooldown_timer.one_shot = true
	cooldown_timer.timeout.connect(_on_cooldown_timeout)
	
	if hitbox:
		hitbox.monitoring = false
		if stats:
			hitbox.damage = stats.damage

func _on_cooldown_timeout() -> void:
	can_attack = true

func update_rotation(direction: Vector2, delta: float) -> void:
	if direction.length() > 0:
		target_rotation = direction.angle()
	
	rotation = lerp_angle(rotation, target_rotation, lerp_speed * delta)

func attack() -> void:
	if can_attack and animation_player:
		can_attack = false
		
		if hitbox:
			hitbox.reset_hit_targets()
			hitbox.monitoring = true
			
			for body in hitbox.get_overlapping_bodies():
				hitbox._try_damage(body)
			for area in hitbox.get_overlapping_areas():
				hitbox._try_damage(area)
			
		animation_player.play("slash")
		
		get_tree().create_timer(0.2).timeout.connect(func(): 
			if hitbox: hitbox.monitoring = false
		)
		
		if stats:
			cooldown_timer.start(stats.attack_cooldown)
		else:
			cooldown_timer.start(0.5)
