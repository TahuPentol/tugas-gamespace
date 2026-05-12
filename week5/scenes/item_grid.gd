extends GridContainer

signal item_taken(index: int)
signal item_placed(item_data: ItemData, index: int)

func update_slot_with_data(item_data: ItemData, index: int) -> void:
	get_child(index).display_item(item_data)

func display_items(items: Array[ItemData]) -> void:
	for i in items.size():
		var inventory_slot = get_child(i)
		inventory_slot.index = i
		inventory_slot.item_taken.connect(func(index: int) -> void: item_taken.emit(index))
		inventory_slot.item_placed.connect(func(item_data: ItemData, index: int) -> void: item_placed.emit(item_data, index))
		if items[i]:
			inventory_slot.display_item(items[i])
