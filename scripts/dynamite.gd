extends RigidBody2D

@export var damage: float = 40.0
@export var explosion_radius: float = 150.0 # Dalam pixel
@export var fuse_time: float = 2.5

@onready var timer: Timer = $Timer
@onready var explosion_area: Area2D = $Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready():
	timer.start(fuse_time)
	timer.timeout.connect(_explode)

func _explode():
	# Ambil semua body yang masuk dalam radius Area2D
	var targets = explosion_area.get_overlapping_bodies()
	
	for body in targets:
		# Cek jika body adalah musuh (misal punya method 'take_damage')
		if body.has_method("take_damage"):
			# Opsional: Hitung damage berdasarkan jarak (Falloff)
			var dist = global_position.distance_to(body.global_position)
			var damage_multiplier = 1.0 - (dist / explosion_radius)
			var final_damage = damage * max(damage_multiplier, 0.2) # Minimal damage 20%
			
			body.take_damage(final_damage)
		
		# Berikan dorongan fisik jika target juga RigidBody2D
		if body is RigidBody2D:
			var push_dir = (body.global_position - global_position).normalized()
			body.apply_central_impulse(push_dir * 300.0)

	# Mainkan partikel dan hapus granat
	_play_explosion_vfx()

func _play_explosion_vfx():
	# Sembunyikan sprite granat agar tidak terlihat saat meledak
	sprite_2d.hide()
	# Matikan tabrakan agar tidak memantul lagi setelah meledak
	collision_shape_2d.set_deferred("disabled", true)
	
	# Trigger partikel (pastikan 'One Shot' aktif di CPUParticles2D)
	#$CPUParticles2D.emitting = true
	
	# Tunggu sebentar agar efek visual selesai sebelum dihapus
	#await get_tree().create_timer(1.0).timeout
	queue_free()
