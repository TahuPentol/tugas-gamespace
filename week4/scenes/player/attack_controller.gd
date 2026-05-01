
class_name AttackController
extends Node

@export var weapon: WeaponComponent

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("hit"):
		if weapon:
			weapon.attack()
