extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect

@export var transition_duration: float = 0.4

var shader_material: ShaderMaterial

func _ready() -> void:
	shader_material = color_rect.material as ShaderMaterial
	shader_material.set_shader_parameter("radius", 1.0)
	color_rect.visible = false

func change_scene(target_scene_path: String) -> void:
	color_rect.visible = true
	
	var tween_in := create_tween()
	
	tween_in.tween_property(shader_material, "shader_parameter/radius", 0.0, transition_duration)\
		.set_trans(Tween.TRANS_QUINT)\
		.set_ease(Tween.EASE_OUT)
	
	await tween_in.finished
	
	get_tree().change_scene_to_file(target_scene_path)
	
	await get_tree().process_frame
	
	var tween_out := create_tween()
	
	tween_out.tween_property(shader_material, "shader_parameter/radius", 1.0, transition_duration)\
		.set_trans(Tween.TRANS_QUINT)\
		.set_ease(Tween.EASE_IN)
	
	await tween_out.finished
	
	color_rect.visible = false
