
class_name HitboxComponent
extends Area2D

@export var damage: float = 10.0
@export var target_groups: Array[String] = ["Enemy"]

var hit_targets: Array[Node] = []

func _on_body_entered(body: Node) -> void:
	_try_damage(body)

func _on_area_entered(area: Area2D) -> void:
	_try_damage(area)

func reset_hit_targets() -> void:
	hit_targets.clear()

func _try_damage(target: Node) -> void:
	if target == owner or target in hit_targets: return 
	
	for group in target_groups:
		if target.is_in_group(group):
			var target_to_damage = null
			if target.has_method("take_damage"):
				target_to_damage = target
			elif target.get_parent().has_method("take_damage"):
				target_to_damage = target.get_parent()
			
			if target_to_damage:
				target_to_damage.take_damage(damage)
				hit_targets.append(target)
				break
