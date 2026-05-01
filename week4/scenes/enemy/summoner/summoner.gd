extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_delay: float = 5

@onready var spawn_point: Marker2D = $SpawnPoint 

func _ready() -> void:
	spawn_enemy()

func spawn_enemy() -> void:
	if not enemy_scene: return

	var enemy = enemy_scene.instantiate()
	enemy.global_position = spawn_point.global_position
	enemy.tree_exited.connect(_on_enemy_removed)

	# PENTING: Tambahkan ke NavigationRegion sebagai child
	# agar musuh mewarisi context navigasi yang sama
	get_parent().add_child.call_deferred(enemy) 

	# Jika musuh punya fungsi setup khusus navigasi:
	if enemy.has_method("initialize_pathfinding"):
		enemy.call_deferred("initialize_pathfinding")

func _on_enemy_removed() -> void:
	await get_tree().create_timer(spawn_delay).timeout
	spawn_enemy()
