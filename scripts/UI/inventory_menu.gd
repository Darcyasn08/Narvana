extends Control

func _ready() -> void:
	update_items()

func update_items() -> void:
	var _item_index: int = 0
	for item: String in Global.inventory["items"]:
		var item_label: InventoryItem = InventoryItem.new()
		item_label.text = str(Global.inventory["items"][item]["name"])
		item_label.desc = Global.inventory["items"][item]["desc"]
		item_label.icon_path = Global.inventory["items"][item]["icon"]
		item_label.custom_minimum_size.x = 240
		$item_list.add_child(item_label)
