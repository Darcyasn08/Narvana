extends Control

var item_buff: Dictionary
var selected_shop_item: int
var previous_selected_item: int = -1

@onready var item_button_inst: Object = preload("res://scenes/UI/inventory_shop_item.tscn")

func _ready() -> void:
	%shop_items_dropbox.hide()
	SignalBus.on_item_removed.connect(remove_item)
	SignalBus.on_buy_shop_item.connect(add_shop_item)
	SignalBus.on_item_selected.connect(select_shop_item)
	update_items()
	$money_label.text = str(Global.coins)

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
		
		#se o player possuir o item
		if Global.inventory["items"][item]["player_has"]:
			var item_label: InventoryItem = InventoryItem.new()
			item_label.text = str(Global.inventory["items"][item]["name"])
			item_label.desc = Global.inventory["items"][item]["desc"]
			item_label.icon_path = Global.inventory["items"][item]["icon"]
			item_label.custom_minimum_size = Vector2(240,260)
			
			if item_buff["damage"] != 0:
				Global.plus_player_damage += item_buff["damage"]
			if item_buff["speed"] != 0:
				Global.plus_player_speed += item_buff["speed"]
			if item_buff["health"] != 0:
				print("tem um item pra vida")
				Global.plus_player_health += item_buff["health"]
				print("plus com item: ",Global.plus_player_health)
				Global.max_player_health += item_buff["health"]
			$item_list.add_child(item_label)
		
		#se o player não possuir o item
		else:
			if item_buff["damage"] != 0:
				Global.plus_player_damage -= item_buff["damage"]
			if item_buff["speed"] != 0:
				Global.plus_player_speed -= item_buff["speed"]
			if item_buff["health"] != 0:
				Global.plus_player_health -= item_buff["health"]
				#Global.max_player_health -= item_buff["health"]
	#refazer o select_shop_item, pro valor dele também entrar
	add_shop_item()
	select_shop_item(Global.selected_shop_item)
	#deixar com que os valores não sejam menores que 0
	adjust_plus_values()
	
	#somar status dos itens com os valores base do player
	add_plus_values()
	
	SignalBus.on_player_health_changed.emit(Global.player_health)
	await get_tree().create_timer(.2).timeout
	SignalBus.on_item_list_updated.emit()

func remove_item(item: String) -> void:
	Global.inventory["items"][item]["player_has"] = false
	update_items()

func adjust_plus_values() -> void:
	if Global.plus_player_damage < 0:
		Global.plus_player_damage = 0
	if Global.plus_player_speed < 0:
		Global.plus_player_speed = 0
	if Global.plus_player_health < 0:
		Global.plus_player_health = 0

func add_plus_values() -> void:
	if Global.player_health != Global.max_player_health:
		pass
	else:
		Global.player_health = Global.base_player_health + Global.plus_player_health
	
	Global.max_player_health = Global.base_player_health + Global.plus_player_health
	#print("1. ",Global.base_player_health, "--",Global.plus_player_health)
	Global.player_damage = Global.base_player_damage + Global.plus_player_damage
	Global.player_speed = Global.base_player_speed + Global.plus_player_speed
	#print("2. ",Global.base_player_health, "--",Global.plus_player_health)
	if Global.player_health > Global.max_player_health:
		Global.player_health = Global.max_player_health
	#print("player health summing: ",Global.player_health, "---",Global.max_player_health)
	SignalBus.on_player_health_changed.emit(Global.player_health)
	#print("vida: ",Global.player_health, " dano: ",Global.player_damage, " velocidade: ",Global.player_speed)

func add_shop_item() -> void:
	if Global.inventory["shop_items"] != {}:
		var next_index: int = 0
		for shop_item: int in Global.inventory["shop_items"]:
			next_index += 1
		next_index -= 1 #para manter dentro dos padrões do index
		var item_label: Label = Label.new()
		item_label.custom_minimum_size.y = 80 
		item_label.text = str(Global.inventory["shop_items"][next_index]["name"])
		#$VBoxContainer.add_child(item_label)
		var item_button: Object = item_button_inst.instantiate()
		item_button.text_name = str(Global.inventory["shop_items"][next_index]["name"])
		item_button.id = next_index
		item_button.size = Vector2(50,40)
		%shop_items_dropbox/VBoxContainer.add_child(item_button)

func select_shop_item(index: int) -> void:
	Global.selected_shop_item = index
	print("selected shop item: ",Global.selected_shop_item)
	#caso outro item tenha sido selecionado antes, tirar os buffs dele
	if previous_selected_item != -1 and index != previous_selected_item:
		if Global.inventory["shop_items"][previous_selected_item]["buff"]["damage"] != 0:
			Global.plus_player_damage -= Global.inventory["shop_items"][previous_selected_item]["buff"]["damage"]
		if Global.inventory["shop_items"][previous_selected_item]["buff"]["speed"] != 0:
			Global.plus_player_speed -= Global.inventory["shop_items"][previous_selected_item]["buff"]["speed"]
		if Global.inventory["shop_items"][previous_selected_item]["buff"]["health"] != 0:
			#Global.max_player_health -= Global.inventory["shop_items"][previous_selected_item]["buff"]["health"]
			Global.plus_player_health -= Global.inventory["shop_items"][previous_selected_item]["buff"]["health"]
	
	#adicionar os buffs do item atual
	if index != -1: #caso seja realmente um item
		if Global.inventory["shop_items"][index]["buff"]["damage"] != 0:
			Global.plus_player_damage += Global.inventory["shop_items"][index]["buff"]["damage"]
		if Global.inventory["shop_items"][index]["buff"]["speed"] != 0:
			Global.plus_player_speed += Global.inventory["shop_items"][index]["buff"]["speed"]
		if Global.inventory["shop_items"][index]["buff"]["health"] != 0:
			print("add vida de item da loja")
			Global.plus_player_health += Global.inventory["shop_items"][index]["buff"]["health"]
			print("plus com item da loja: ",Global.plus_player_health)
		add_plus_values()
		%shop_item_icon.texture = load(Global.inventory["shop_items"][index]["icon"])
		if Global.inventory["shop_items"][index]["buff"]["damage"]:
			$shop_item_container/selected_item_stats.text = str("+:",Global.inventory["shop_items"][index]["buff"]["damage"], "dano")
		elif Global.inventory["shop_items"][index]["buff"]["health"] != 0:
			$shop_item_container/selected_item_stats.text = str("+",Global.inventory["shop_items"][index]["buff"]["health"], " vida")
		elif Global.inventory["shop_items"][index]["buff"]["speed"] != 0:
			$shop_item_container/selected_item_stats.text = str("+",Global.inventory["shop_items"][index]["buff"]["speed"], " velocidade")
		%shop_items_dropbox.hide()
		previous_selected_item = index

func _on_open_item_select_pressed() -> void:
	%shop_items_dropbox.show()
