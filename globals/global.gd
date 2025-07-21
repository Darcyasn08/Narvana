extends Node

#game
var has_started_game: bool = false

#player
var player_can_move: bool = true
var player_can_attack: bool = true
var base_player_health: int = 6
var base_player_damage: float = 200.0
var base_player_speed: float = 8.0
var current_weapon: String = "bat"

var player_health: int = 6
var player_damage: float = 200.0
var player_speed: float = 8.0

var plus_player_health: int
var plus_player_damage: float
var plus_player_speed: float

#enemies
var dust_damage: float= 1500.0
var house_health: int = 5000


#world positions
var player_base_pos: Vector3 = Vector3(0,5,0)
var player_normal_pos: Vector3 = Vector3(0,5,0)
var player_first_level_pos: Vector3



var enemies: Array = [
	["res://scenes/enemies/coin.tscn","res://scenes/enemies/pig_bank.tscn","res://scenes/enemies/car.tscn", "res://scenes/enemies/pearl_collar.tscn", "res://scenes/enemies/house.tscn"], #uma fase
	[],
	[]
]

#levels
var dead_enemies_first_level: Array = [
	[0, 0],
	[0, 0],
	[0, 0],
	[0, 0],
]

var current_room: int = 0
var current_world: int
enum worlds {NORMAL, FIRST_LEVEL, SECOND_LEVEL}

var completed_levels: Dictionary = {
	"first_level": false,
	"second_level": false,
	"third_level": false
}

var inventory: Dictionary = {
	"current_weapon": current_weapon,
	"current_spell": "",
	"items": {
		"photo": {
			"player_has": true,
			"icon": "res://icon.svg",
			"name": "Foto da banda",
			"desc": "Dessa foto, vem muitas memórias, e uma certa vontade de continuar (+ataque)",
			"buff": {
				"damage": 50,
				"health": 0,
				"speed": 0,
			},
		},
		"teddy": {
			"player_has": true,
			"icon": "res://UI/inventory/teddy-bear.png",
			"name": "Ursinho de pelúcia antigo",
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
				"speed": 2,
			},
		}
	}
}

var cutscenes: Dictionary = {
	"start": false,
	"final": false
}

enum npcs {crab, master}

var dialogs: Dictionary = {
	"crab": {
		"dialog_tree": {
			"is_first_time": true,
			"first_dialog": {
				"text": "hi",
				"options": {},
			},
			"middle": {
				0: {
					"text": "Ah, olá",
					"options": {}
				},
				1: {
					"text": "Você parece ser novo por aqui", 
					"options": {}
				},
				2: {
					"text": "Eu sou o caranguejo, caso precise de algo pra comer, minha loja sempre está aberta",
					"options": {}
				},
				3: {
					"text": "Quer olhar o cardápio?",
					"options": {
						0: {
							"text": "Sim",
							"ignite": "quest",
						},
						1: {
							"text": "Não",
							"ignite": "exit"
						},
					}
				},
				4: {
					"text": "Até logo!",
					"options": {}
				}
			},
			"quest": {
				#none/ongoing/done - vai checar qual tá cada vez que o dialogo for acionado
				"status": "none",
				"id": "socks",
				"text": "notas da lia: juro que eu faço algo melhor depois :'), só finge que tem um cardápio aqui",
				"options": {}
			},
			"exit": {
				"text": "Até logo, rapaz",
				"options": {}
			}
		}
	},
	"jellyfish": {
		"dialog_tree": {
			"is_first_time": true,
			"first_dialog": {
				"text": "hi",
				"options": {}
			},
			"middle": {
				0: {
					"text": "Oi, eu sou o Anderson",
					"options": {}
				},
				1: {
					"text": "Dizem que eu sou o cara mais maneiro daqui... Você acredita nisso? :D", 
					"options": {}
				},
				2: {
					"text": "Bom, eu tenho negócios a fazer, te vejo alguma hora",
					"options": {}
				},
			},
			"quest": {
				#none/ongoing/done - vai checar qual tá cada vez que o dialogo for acionado
				"status": "none",
				"id": "secret_stash",
				"text": "(fazer um texto aqui alguma hora)",
				"options": {}
			},
			"exit": {
				"text": "Te vejo mais tarde",
				"options": {}
			}
		}
	},
		
	"grandma": {
		"dialog_tree": {
			"is_first_time": true,
			"first_dialog": {
				"text": "hi",
				"options": {}
			},
			"middle": {
				0: {
					"text": "Oi, eu sou o Anderson",
					"options": {}
				},
				1: {
					"text": "Dizem que eu sou o cara mais maneiro daqui... Você acredita nisso? :D", 
					"options": {}
				},
				2: {
					"text": "Bom, eu tenho negócios a fazer, te vejo alguma hora",
					"options": {}
				},
			},
			"quest": {
				#none/ongoing/done - vai checar qual tá cada vez que o dialogo for acionado
				"status": "none",
				"id": "secret_stash",
				"text": "(fazer um texto aqui alguma hora)",
				"options": {}
			},
			"exit": {
				"text": "Te vejo mais tarde",
				"options": {}
			}
		}
	},
	
	"master": {
		"is_first_time": true,
		"dialog_tree": {
			"middle": {
				0: {
					"text": "Olá garoto, vejo que você é bem jovem",
					"options": {},
				},
				1: {
					"text": "E pelas suas vestimentas, é de fora, não é?",
					"options": {},
				},
				2: {
					"text": "Hmm... também tem um ar de tristeza envolta de ti",
					"options": {},
				},
				3: {
					"text": "Venha, posso ajudar a sua jovem alma a curar todas as suas tristezas",
					"options": {
						0: {
							"text": "Ok",
							"ignite": "function",
						},
						1: {
							"text": "Ok",
							"ignite": "function",
						},
					},
				},
				4: {
					"text": "Após se aproximar no portal, entre nele usando [e] e vou te ajudar nessa jornada",
					"options": {},
				},
			},
			"function": {
				"status": "none",
				"text": "(clica [e] pra continuar, não pensei nesse dialogo ainda)",
				"id": "open_first_level_portal",
				"options": {},
			}
		}
	},
	
	"first_level_master": {
		"is_first_time": true,
	},
	"second_level_master": {
		"is_first_time": true,
	},
	"third_level_master": {
		"is_first_time": true,
	},
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
