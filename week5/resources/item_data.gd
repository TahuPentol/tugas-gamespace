class_name ItemData
extends Resource

@export var item_name: String
@export var texture: Texture2D
@export var quantity: int = 1
@export var max_stack_size: int = 12

var uid: String:
	get():
		var res = item_name.to_lower().replace(" ", "_") # ubah uid, contoh Golden Apple menjadi golden_apple
		return res
