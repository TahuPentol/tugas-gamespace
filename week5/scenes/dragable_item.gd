extends TextureRect

@onready var quantity_label: Label = %Quantity

var item_data: ItemData = null

func _ready() -> void:
	display_item(item_data)

func display_item(new_item_data: ItemData) -> void:
	if new_item_data:
		item_data = new_item_data
		texture = item_data.texture
		update_quantity_label()

func _process(delta: float) -> void:
	# Agar item yang di drag dapat mengikuti posisi mouse
	self.global_position = get_global_mouse_position() - (get_rect().size / 2.0)

func update_quantity_label() -> void:
	if item_data.quantity > 1:
		quantity_label.text = str(item_data.quantity)
		quantity_label.show()
	else:
		quantity_label.hide()
