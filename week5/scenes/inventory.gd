extends PanelContainer

@onready var item_grid: GridContainer = %ItemGrid

@export var items: Array[ItemData] = [] # List item

var inventory_size: int = 24 # Ukuran grid inventory?

func _ready() -> void:
	init_inventory()
	item_grid.display_items(items)
	item_grid.item_taken.connect(_on_item_taken)
	item_grid.item_placed.connect(_on_item_placed)
	#print(items)
	
	#var new_item = ItemData.new()
	#new_item.item_name = "Tear Drop"
	#new_item.quantity = 24
	#new_item.max_stack_size = 12
	#new_item.texture = load("res://assets/items/tear_drop.png")
	#add_item(new_item)

func init_inventory() -> void:
	var empty_slots: Array[ItemData] # Slot di inventory yang kosong
	empty_slots.resize(inventory_size - items.size()) # Kurangi empty slot jika ada item
	empty_slots.fill(null) # Isi dengan null
	items += empty_slots # Ini masih tidak paham?

func _on_item_taken(index: int) -> void:
	items[index] = null

func _on_item_placed(item_data: ItemData, index: int) -> void:
	items[index] = item_data

func add_item(item_data: ItemData) -> void:
	var current_item_quantity = item_data.quantity
	for i in items.size():
		if !items[i]:
			continue
		if items[i].uid == item_data.uid:
			var top_up_amount = min(current_item_quantity, items[i].max_stack_size - items[i].quantity)
			items[i].quantity += top_up_amount
			current_item_quantity -= top_up_amount
	
	for i in items.size():
		if items[i]:
			continue
		if current_item_quantity <= 0:
			break
		var new_item_data = item_data.duplicate()
		if current_item_quantity < item_data.max_stack_size:
			new_item_data.quantity = current_item_quantity
			items[i] = new_item_data
			current_item_quantity = 0
			break
		new_item_data.quantity = new_item_data.max_stack_size
		current_item_quantity -= new_item_data.max_stack_size
		items[i] = new_item_data
	
	for i in items.size():
		if items[i]:
			item_grid.update_slot_with_data(items[i], i)
