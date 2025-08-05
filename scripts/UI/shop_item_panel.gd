extends Control

@export var id: int
@export var item_name: String
@export var item_desc: String
@export var item_price: float
#@export var icon: Texture2D

func _ready() -> void:
	#icon = load(Global.shop_items[id]["icon"])
	$item_name_label.text = item_name
	$item_desc_label.text = item_desc
	$item_price_label.text = str("$",item_price)
