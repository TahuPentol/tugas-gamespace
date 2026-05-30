extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect

@export var transition_duration: float = 0.5

func change_scene(target_scene_path: String) -> void:
	var tween_in := create_tween()
	
	tween_in.tween_property(color_rect, "modulate:a", 1.0, transition_duration)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
	
	await tween_in.finished
	
	get_tree().change_scene_to_file(target_scene_path)
	
	await get_tree().process_frame
	
	var tween_out := create_tween()
	
	tween_out.tween_property(color_rect, "modulate:a", 0.0, transition_duration)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
	
	await tween_out.finished
