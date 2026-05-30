class_name TilemapController
extends Node

@export var player: CharacterBody2D
@export var tilemap_layer_group: String = "Tilemap"
@export var custom_data_name: String = "surface"

var tilemap_layer: TileMapLayer
var last_multiplier: float = -1.0

var basic_multiplier: float = 1.0
var speed_up_multiplier: float = 3.0

func _ready() -> void:
	if not player and get_parent() is CharacterBody2D:
		player = get_parent() as CharacterBody2D

	tilemap_layer = get_tree().get_first_node_in_group(tilemap_layer_group) as TileMapLayer
	apply_current_tile_effect()

func _physics_process(_delta: float) -> void:
	apply_current_tile_effect()

func apply_current_tile_effect() -> void:
	if player == null or tilemap_layer == null:
		return
	
	var multiplier := resolve_multiplier_from_tilemap()
	
	if is_equal_approx(multiplier, last_multiplier):
		return

	player.set_external_speed_multiplier(multiplier)
	last_multiplier = multiplier

func resolve_multiplier_from_tilemap() -> float:
	var local_pos := tilemap_layer.to_local(player.global_position)
	var cell := tilemap_layer.local_to_map(local_pos)
	
	var tile_data := tilemap_layer.get_cell_tile_data(cell)
	if tile_data == null:
		return basic_multiplier 
	
	var surface_name = tile_data.get_custom_data(custom_data_name)
	
	match str(surface_name):
		"basic":
			return basic_multiplier
		"speed_up":
			return speed_up_multiplier
		_:
			return basic_multiplier
