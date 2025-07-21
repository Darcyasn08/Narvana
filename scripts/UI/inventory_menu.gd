extends Control

var item_buff: Dictionary

func _ready() -> void:
	SignalBus.on_item_removed.connect(remove_item)
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
			if Global.inventory["items"][item]["player_has"]:
				if item_buff["damage"] != 0:
					Global.plus_player_damage += item_buff["damage"]
				if item_buff["speed"] != 0:
					Global.plus_player_speed += item_buff["speed"]
				if item_buff["health"] != 0:
					Global.plus_player_health += item_buff["health"]
					#print("health before: ", Global.player_health)
					SignalBus.on_player_health_changed.emit(Global.player_health)
			$item_list.add_child(item_label)
		else:
			print("player doesnt have this item anymore... ", item)
	SignalBus.on_player_health_changed.emit(Global.player_health)
	await get_tree().create_timer(.2).timeout
	SignalBus.on_item_list_updated.emit()

func remove_item(item: String) -> void:
	Global.inventory["items"][item]["player_has"] = false
	SignalBus.on_player_health_changed.emit(Global.player_health)
	update_items()

func _on_timer_timeout() -> void:
	#Global.inventory["items"]["teddy"]["player_has"] = false
	update_items()
