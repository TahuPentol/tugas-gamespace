extends Area2D

func _on_body_entered(body: Node2D) -> void:
	change_floor.call_deferred()

func change_floor() -> void:
	match Week8.current_floor:
		Week8.floor.floor_1:
			Week8.current_floor = Week8.floor.floor_2
			TransitionManager.change_scene("res://week8/floor_2.tscn")
		Week8.floor.floor_2:
			Week8.current_floor = Week8.floor.floor_1
			TransitionManager.change_scene("res://week8/floor_1.tscn")
