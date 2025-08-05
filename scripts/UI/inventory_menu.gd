extends Control

var item_buff: Dictionary

func _ready() -> void:
	SignalBus.on_item_removed.connect(remove_item)
	SignalBus.on_buy_shop_item.connect(add_shop_item)
	update_items()

func set_items() -> void:
	pass

func update_items() -> void:
	for child in $item_list.get_children():
		child.queue_free()
	var _item_index: int = 0
	
	#reseta tudo, pra depois colocar um por um de novo
	Global.plus_player_damage = 0
	Global.plus_player_speed = 0
	Global.plus_player_health = 0
	
	for item: String in Global.inventory["items"]:
		item_buff = Global.inventory["items"][item]["buff"]
		#print("ITEM ATUAL: ",item)
		
		#se o player possuir o item
		if Global.inventory["items"][item]["player_has"]:
			var item_label: InventoryItem = InventoryItem.new()
			item_label.text = str(Global.inventory["items"][item]["name"])
			item_label.desc = Global.inventory["items"][item]["desc"]
			item_label.icon_path = Global.inventory["items"][item]["icon"]
			item_label.custom_minimum_size.x = 240
			
			if item_buff["damage"] != 0:
				Global.plus_player_damage += item_buff["damage"]
				print("add damage ",item_buff["damage"])
				print(Global.player_damage)
			if item_buff["speed"] != 0:
				Global.plus_player_speed += item_buff["speed"]
			if item_buff["health"] != 0:
				Global.plus_player_health += item_buff["health"]
				Global.max_player_health += item_buff["health"]
			$item_list.add_child(item_label)
		
		#se o player não possuir o item
		else:
			print("player doesnt have this item anymore... ", item)
			if item_buff["damage"] != 0:
				#print("dano retirado!!")
				Global.plus_player_damage -= item_buff["damage"]
			if item_buff["speed"] != 0:
				#print("velocidade retirada!!")
				Global.plus_player_speed -= item_buff["speed"]
			if item_buff["health"] != 0:
				#print("vida retirada!!")
				#print("vida antes: ",Global.plus_player_health)
				Global.plus_player_health -= item_buff["health"]
				Global.max_player_health -= item_buff["health"]
				#print("vida depois: ",Global.plus_player_health)
	
	#deixar com que os valores não sejam menores que 0
	adjust_plus_values()
	
	#somar status dos itens com os valores base do player
	add_plus_values()
	
	#print("PLUS HEALTH: ",Global.plus_player_health, ". DAMAGE: ", Global.plus_player_damage,". SPEED: ",Global.plus_player_speed)
	
	SignalBus.on_player_health_changed.emit(Global.player_health)
	await get_tree().create_timer(.2).timeout
	SignalBus.on_item_list_updated.emit()

func remove_item(item: String) -> void:
	Global.inventory["items"][item]["player_has"] = false
	SignalBus.on_player_health_changed.emit(Global.player_health)
	update_items()

func adjust_plus_values() -> void:
	if Global.plus_player_damage < 0:
		Global.plus_player_damage = 0
	if Global.plus_player_speed < 0:
		Global.plus_player_speed = 0
	if Global.plus_player_health < 0:
		Global.plus_player_health = 0

func add_plus_values() -> void:
	Global.max_player_health = Global.base_player_health + Global.plus_player_health
	Global.player_health = Global.base_player_health + Global.plus_player_health
	Global.player_damage = Global.base_player_damage + Global.plus_player_damage
	Global.player_speed = Global.base_player_speed + Global.plus_player_speed
	
	print(Global.player_damage)
	
	if Global.player_health > Global.max_player_health:
		Global.player_health = Global.max_player_health
	
	SignalBus.on_player_health_changed.emit(Global.player_health)
	#print("vida: ",Global.player_health, " dano: ",Global.player_damage, " velocidade: ",Global.player_speed)

func add_shop_item() -> void:
	for shop_item in Global.inventory["shop_items"]:
		var item_label: Label = Label.new()
		item_label.custom_minimum_size.y = 50
		item_label.text = str(shop_item)
		$VBoxContainer.add_child(item_label)
		print(shop_item)
