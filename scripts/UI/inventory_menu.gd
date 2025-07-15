extends Control

var item_buff: Dictionary

func _ready() -> void:
	update_items()

func update_items() -> void:
	for child in $item_list.get_children():
		child.queue_free()
	var _item_index: int = 0
	for item: String in Global.inventory["items"]:
		if Global.inventory["items"][item]["player_has"]:
			item_buff = Global.inventory["items"][item]["buff"]
			var item_label: InventoryItem = InventoryItem.new()
			item_label.text = str(Global.inventory["items"][item]["name"])
			item_label.desc = Global.inventory["items"][item]["desc"]
			item_label.icon_path = Global.inventory["items"][item]["icon"]
			item_label.custom_minimum_size.x = 240
			if item_buff["damage"] != 0:
				print("damage before: ", Global.player_damage)
				Global.player_damage += item_buff["damage"]
				print("damage after: ", Global.player_damage)
			$item_list.add_child(item_label)
		else:
			print("player doesnt have this item anymore... ", item)
	SignalBus.on_item_list_updated.emit()

func _on_timer_timeout() -> void:
	Global.inventory["items"]["coffee"]["player_has"] = false
	update_items()
