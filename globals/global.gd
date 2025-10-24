extends Node

#game
var current_save: int = 0
var has_started_game: bool = false
var game_paused: bool = false
var next_scene: String = "res://scenes/worlds/normal_world.tscn"
var loading_screen: Object = preload("res://scenes/UI/loading_screen.tscn")
var time_lapsed: int = 0

#player
var player_can_move: bool = true
var player_can_attack: bool = true
var current_weapon: int = 1
var n: int = 0
var rotation_mouse_axis_y: int = 1
var rotation_mouse_axis_x: int = 1

enum weapons {NONE, BAT, TONFA, MANGUAL}
var unlocked_weapons: Dictionary = {
	0: true,
	1: true,
	2: false,
	3: false
}

var base_player_health: int = 6
var base_player_damage: float = 200.0
var base_player_speed: float = 8.0

var player_health: int = 6
var player_damage: float = 180.0
var player_speed: float = 8.0

var plus_player_health: int
var plus_player_damage: float
var plus_player_speed: float

var max_player_health: int

var coins: int = 100

#enemies
var dust_damage: float= 1000.0
var house_health: int = 8000
var knock_multi: float = 5.0

var mouse_sens: float = .11

#world positions
var player_base_pos: Vector3 = Vector3(0,5,0)
var player_normal_pos: Vector3 = Vector3(0,0, -45)
var player_first_level_pos: Vector3 = Vector3(1.3,2.7,40.5)

var worlds_files: Dictionary = {
	"normal_world": "res://scenes/worlds/normal_world.tscn",
	"first_level": "res://scenes/worlds/first_level.tscn"
}

var enemies: Array = [
	["res://scenes/enemies/coin.tscn","res://scenes/enemies/pig_bank.tscn","res://scenes/enemies/car.tscn", "res://scenes/enemies/pearl_collar.tscn", "res://scenes/enemies/house.tscn", "res://scenes/enemies/coin_trap.tscn"], #uma fase
	["res://scenes/enemies/ex_gf.tscn", "res://scenes/enemies/dolphin.tscn", "res://scenes/enemies/band.tscn", "res://scenes/enemies/el_gran_capo.tscn"],
	[]
]

#levels
var dead_enemies_first_level: Array = [
	[0, 0], #inimigos derrotados/objetivo
]

var dead_enemies_second_level: Array = [
	[0, 0], #inimigos derrotados/objetivo
]

var dead_enemies_third_level: Array = [
	[0, 0], #inimigos derrotados/objetivo
]

var current_room: int = 0
var current_world: int = 0
enum worlds {NORMAL, FIRST_LEVEL, SECOND_LEVEL}
var last_saved_pos: Vector3 = Vector3(0,0,-16)

var shop_items: Dictionary = {
	0: {
		"name": "Doce",
		"desc": "É bem docinho",
		"price": 45,
		"buff": {
			"damage": 0,
			"health": 0,
			"speed": 1,
		},
		"icon": "res://UI/inventory/teddy-bear.png"
	},
	1: {
		"name": "Chá",
		"desc": "Acalma bastante",
		"buff": {
			"damage": 0,
			"health": 1,
			"speed": 0,
		},
		"price": 20,
		"icon": "res://UI/inventory/coffee-cup.png"
	}
}

var completed_levels: Dictionary = {
	"first_level": false,
	"second_level": false,
	"third_level": false
}

var reset_completed_levels: Dictionary = {
	"first_level": false,
	"second_level": false,
	"third_level": false
}

var inventory: Dictionary = {
	"current_spell": "",
	"items": {
		"car_keys": {
			"player_has": true,
			"icon": "res://UI/inventory/car-keys.png",
			"name": "Chaves do carro",
			"desc": "Um carrinho pra ir trabalhar (+dano)",
			"buff": {
				"damage": 20,
				"health": 0,
				"speed": 0,
			},
		},
		"jewel": {
			"player_has": true,
			"icon": "res://UI/inventory/jewel.png",
			"name": "Jóias",
			"desc": "Caras e lindas (+velocidade)",
			"buff": {
				"damage": 0,
				"health": 0,
				"speed": 1,
			},
		},
		"photo": {
			"player_has": true,
			"icon": "res://icon.svg",
			"name": "Foto da banda",
			"desc": "Dessa foto, vem muitas memórias, e uma certa vontade de continuar (+ataque)",
			"buff": {
				"damage": 20,
				"health": 0,
				"speed": 0,
			},
		},
		"plush": {
			"player_has": true,
			"icon": "res://UI/inventory/teddy-bear.png",
			"name": "Pelúcia antiga",
			"desc": "Algo dele te traz um conforto muito grande (+vida)",
			"buff": {
				"damage": 0,
				"health": 1,
				"speed": 0,
			},
		},
		"coffee": {
			"player_has": true,
			"icon": "res://UI/inventory/coffee-cup.png",
			"name": "Copo de café",
			"desc": "É sempre bom um café pela manhã (+velocidade)",
			"buff": {
				"damage": 0,
				"health": 0,
				"speed": 1,
			},
		},
	},
	"shop_items": {}
}

var reset_inventory: Dictionary = {
	"current_spell": "",
	"items": {
		"car_keys": {
			"player_has": true,
			"icon": "res://UI/inventory/car-keys.png",
			"name": "Chaves do carro",
			"desc": "Um carrinho pra ir trabalhar (+dano)",
			"buff": {
				"damage": 20,
				"health": 0,
				"speed": 0,
			},
		},
		"jewel": {
			"player_has": true,
			"icon": "res://UI/inventory/jewel.png",
			"name": "Jóias",
			"desc": "Caras e lindas (+velocidade)",
			"buff": {
				"damage": 0,
				"health": 0,
				"speed": 1,
			},
		},
		"photo": {
			"player_has": true,
			"icon": "res://icon.svg",
			"name": "Foto da banda",
			"desc": "Dessa foto, vem muitas memórias, e uma certa vontade de continuar (+ataque)",
			"buff": {
				"damage": 20,
				"health": 0,
				"speed": 0,
			},
		},
		"plush": {
			"player_has": true,
			"icon": "res://UI/inventory/teddy-bear.png",
			"name": "Pelúcia antiga",
			"desc": "Algo dele te traz um conforto muito grande (+vida)",
			"buff": {
				"damage": 0,
				"health": 1,
				"speed": 0,
			},
		},
		"coffee": {
			"player_has": true,
			"icon": "res://UI/inventory/coffee-cup.png",
			"name": "Copo de café",
			"desc": "É sempre bom um café pela manhã (+velocidade)",
			"buff": {
				"damage": 0,
				"health": 0,
				"speed": 1,
			},
		},
	},
	"shop_items": {}
}


enum npcs {crab, master}

var npc_manager: Dictionary = {
	"crab": {
		"is_first_time": true,
	},
	"jellyfish": {
		"is_first_time": true,
	},
	"grandma": {
		"is_first_time": true,
	},
	"master": {
		"is_first_time": true
	},
	"gardener": {
		"is_first_time": true
	},
	"master_end_first_level": {
		"is_first_time": true
	},
	"second_master": {
		"is_first_time": true
	},
	"master_first_level": {
		"is_first_time": true
	},
}

var reset_npc_manager: Dictionary = {
	"crab": {
		"is_first_time": true,
	},
	"jellyfish": {
		"is_first_time": true,
	},
	"grandma": {
		"is_first_time": true,
	},
	"master": {
		"is_first_time": true
	},
	"second_master": {
		"is_first_time": true
	},
	"master_first_level": {
		"is_first_time": true
	},
}


var cutscenes: Dictionary = {
	"start": false,
	"final": false
}

var reset_cutscenes: Dictionary = {
	"start": false,
	"final": false
}

var quests: Dictionary = {
	"crab": {
		"quest_1": {
			"title": "helping foot",
			"desc": "give crab a pair of socks",
			"item_to_give": "socks"
		}
	},
	"grandma": {
		"quest_1": {
			"title": "flowers for grandma",
			"desc": "give grandma some flowers",
			"item_to_give": "flower bouquet"
		}
	}
}

var crab_diag: Dictionary = {
	"name": "crab junior",
	"missions": {
		0: [
			"your first missions is..",
			"give me your phone"
		]
	},
	
	"daily": {
		0: [
			"hey soul sister",
			"i dont care"
		],
		1: [
			"my godness!",
			"youre a bitch."
		]
	}
}
