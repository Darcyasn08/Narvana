extends CanvasLayer

var shop_item_panel_inst: Object = preload("res://scenes/UI/shop_item_panel.tscn")
@onready var shop_item_pos_node: Vector2 = %shop_item_pos_node.position #(mudar nome de acordo)
var item_panel_pos: Vector2

var item_array: Array
var selected_index: int = 0

var price_list: Array = []

func _ready() -> void:
	$coins_label.text = str("$",Global.coins)
	item_panel_pos = shop_item_pos_node
	print(item_panel_pos)
	create_items()

func create_items() -> void:
	for id: int in Global.shop_items:
		var shop_item_panel: Object = shop_item_panel_inst.instantiate()
		shop_item_panel.position = item_panel_pos
		shop_item_panel.item_name = Global.shop_items[id]["name"]
		shop_item_panel.item_desc = Global.shop_items[id]["desc"]
		shop_item_panel.item_price = str(Global.shop_items[id]["price"])
		shop_item_panel.id = id
		add_child(shop_item_panel)
		item_array.append(shop_item_panel)
		price_list.append(Global.shop_items[id]["price"])
		item_panel_pos += Vector2(0,230)
	$item_list/selected_item_icon/item_icon.texture = load(Global.shop_items[selected_index]["icon"])

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("down_arrow"):
		if selected_index >= item_array.size() - 1:
			selected_index = selected_index
		else:
			selected_index += 1
			$item_list/Polygon2D.position += Vector2(0, 230)
		change_selected_item(selected_index)
	if event.is_action_pressed("up_arrow"):
		if selected_index <= 0:
			selected_index = selected_index
		else:
			selected_index -= 1
			$item_list/Polygon2D.position -= Vector2(0, 230)
		change_selected_item(selected_index)
	

func change_selected_item(index: int) -> void:
	#mudar a foto gigante do item de acordo com o item selecionado
	#$item_list/selected_item_icon/item_icon.texture = load(item_array[index]["icon"])
	$item_list/selected_item_icon/item_icon.texture = load(Global.shop_items[index]["icon"])

func buy_item() -> void:
	#fazer ele pegar o id do item que foi clicado com o botão, de alguma forma
	Global.coins -= Global.shop_items[selected_index]["price"]
	print("Compra efetuada! Dinheiro restante: ", Global.coins)
	$coins_label.text = str("$",Global.coins)
	
	var n: int = 0
	for shop_item: int in Global.inventory["shop_items"]:
		n += 1
	
	print(Global.shop_items[selected_index]["name"])
	Global.inventory["shop_items"][n] = Global.shop_items[selected_index]["name"]
	Global.inventory["shop_items"][n] = Global.shop_items[selected_index]["buff"]
	print(Global.inventory["shop_items"])
	
	SignalBus.on_buy_shop_item.emit()
	
	#Global.inventory["shop_items"][Global.shop_items[selected_index]]["name"] = Global.shop_items[selected_index]["name"]
	#Global.inventory["shop_items"][Global.shop_items[selected_index]]["buff"] = Global.shop_items[selected_index]["buff"]
	#print(Global.inventory["shop_items"][selected_index])
	#rodar algum tipo de animação ou efeito de compra aqui

func _on_buy_button_pressed() -> void:
	buy_item()

func _on_exit_button_pressed() -> void:
	hide()
	$item_list.hide()
	#await get_tree().create_timer(.2)
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false
	Global.game_paused = false
	SignalBus.on_game_paused.emit(Global.game_paused)


func _on_timer_timeout() -> void:
	hide()
