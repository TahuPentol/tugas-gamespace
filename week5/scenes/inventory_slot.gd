extends TextureRect

signal item_taken(idx: int)
signal item_placed(item_data: ItemData, idx: int)

@onready var item_display_rect: TextureRect = %ItemDisplayRect
@onready var quantity_label: Label = %Quantity

@export var dragable_item_scene: PackedScene

var slot_item_data: ItemData = null
var index: int = -1

func _ready() -> void:
	gui_input.connect(_on_gui_input)

func display_item(item_data: ItemData) -> void:
	slot_item_data = item_data
	item_display_rect.texture = slot_item_data.texture
	update_quantity_label()

# Nerima input mouse
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var held_item = get_tree().get_first_node_in_group("dragable_item")
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			if !slot_item_data:
				if held_item:
					place_item(held_item)
			else:
				if !held_item:
					pick_item(slot_item_data)
				else:
					if slot_item_data.uid != held_item.item_data.uid:
						swap_item(held_item, slot_item_data)
						return
					
					var quantity_sum = slot_item_data.quantity + held_item.item_data.quantity
					if quantity_sum > slot_item_data.max_stack_size:
						if slot_item_data.quantity < slot_item_data.max_stack_size:
							var diff = slot_item_data.max_stack_size - slot_item_data.quantity
							stack(diff)
							held_item.item_data.quantity -= diff
							held_item.update_quantity_label()
					else:
						stack(held_item.item_data.quantity)
						held_item.queue_free()
		if event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
			if held_item:
				if !slot_item_data:
					place_one(held_item)
				else:
					if slot_item_data.uid != held_item.item_data.uid:
						swap_item(held_item, slot_item_data)
						return
					var quantity_sum = slot_item_data.quantity + 1
					if quantity_sum > slot_item_data.max_stack_size:
						return
					stack(1)
					held_item.item_data.quantity -= 1
					held_item.update_quantity_label()
					if !held_item.item_data.quantity:
						held_item.queue_free()
			else:
				if !slot_item_data or slot_item_data.quantity == 1:
					return
				split()

func pick_item(item_data: ItemData) -> void:
	make_item_dragable(item_data)
	item_taken.emit(index)
	quantity_label.hide()

func make_item_dragable(item_data: ItemData) -> void:
	var dragable_item = dragable_item_scene.instantiate()
	dragable_item.item_data = item_data
	get_tree().root.add_child(dragable_item)
	
	item_display_rect.texture = null
	slot_item_data = null

func place_item(held_item: Node) -> void:
	display_item(held_item.item_data)
	held_item.queue_free()
	item_placed.emit(held_item.item_data, index)
	update_quantity_label()

func swap_item(held_item: Node, item_data: ItemData) -> void:
	var temp = item_data.duplicate()
	item_taken.emit(index)
	display_item(held_item.item_data)
	item_placed.emit(held_item.item_data, index)
	held_item.item_data = temp
	held_item.display_item(temp)

func update_quantity_label() -> void:
	if slot_item_data.quantity > 1:
		quantity_label.text = str(slot_item_data.quantity)
		quantity_label.show()
	else:
		quantity_label.hide()

func stack(q: int) -> void:
	slot_item_data.quantity += q
	update_quantity_label()
	item_placed.emit(slot_item_data, index)

func place_one(held_item: Node) -> void:
	held_item.item_data.quantity -= 1
	held_item.update_quantity_label()
	var held_item_data = held_item.item_data.duplicate()
	held_item_data.quantity = 1
	display_item(held_item_data)
	item_placed.emit(held_item_data, index)
	
	if !held_item.item_data.quantity:
		held_item.queue_free()

func split() -> void:
	var dragable_item_data = slot_item_data.duplicate()
	dragable_item_data.quantity /= 2
	slot_item_data.quantity -= dragable_item_data.quantity
	
	var dragable_item = dragable_item_scene.instantiate()
	dragable_item.item_data = dragable_item_data
	get_tree().root.add_child(dragable_item)
	update_quantity_label()
	item_placed.emit(slot_item_data, index)
