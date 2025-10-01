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

var mouse_sens: float = .11

#world positions
var player_base_pos: Vector3 = Vector3(0,5,0)
var player_normal_pos: Vector3 = Vector3(0,0,-26)
var player_first_level_pos: Vector3 = Vector3(1.3,2.7,40.5)

var worlds_files: Dictionary = {
	"normal_world": "res://scenes/worlds/normal_world.tscn",
	"first_level": "res://scenes/worlds/first_level.tscn"
}

var enemies: Array = [
	["res://scenes/enemies/coin.tscn","res://scenes/enemies/pig_bank.tscn","res://scenes/enemies/car.tscn", "res://scenes/enemies/pearl_collar.tscn", "res://scenes/enemies/house.tscn", "res://scenes/enemies/coin_trap.tscn"], #uma fase
	["res://scenes/enemies/ex_gf.tscn"],
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

var dialogs: Dictionary = {
	"crab": {
		"name": "Caranguejo",
		"is_first_time": true,
		"dialog_tree": {
			"first_dialog": {
				"text": "hi",
				"options": {},
			},
			"middle": {
				0: {
					"text": "Opa, mais um turista",
					"options": {}
				},
				1: {
					"text": "Mas você não parece com aquelas sardinhas que normalmente vêm aqui", 
					"options": {}
				},
				2: {
					"text": "Elas me matam de trabalhar",
					"options": {}
				},
				3: {
					"text": "Bom, se você por acaso quiser comer nos dias que passar aqui, eu estarei disponível",
					"options": {}
				},
				4: {
					"text": "Gostaria de pedir algo?",
					"options": {
						0: {
							"text": "Sim",
							"ignite": "function",
						},
						1: {
							"text": "Não",
							"ignite": "exit"
						},
					}
				},
				5: {
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
			"function": {
				"status": "none",
				"text": "No capricho! Se quiser mais alguma coisa é só falar",
				"id": "open_shop_screen",
				"options": {},
			},
			"exit": {
				"text": "Estarei te esperando outro dia, hein",
				"options": {}
			},
			"middle_done": {
				0: {
					"text": "Oi de novo :)",
					"options": {
						0: {
							"text": "Ver loja",
							"ignite": "function",
						},
						1: {
							"text": "Tchau :)",
							"ignite": "exit",
						}
					},
				},
			},
		}
	},
	"jellyfish": {
		"name": "Água-viva",
		"is_first_time": true,
		"dialog_tree": {
			"middle": {
				0: {
					"text": "Olá, como vai?",
					"options": {}
				},
			},
			"middle_done": {
				0: {
					"text": "Já não te disse oi antes?...",
					"options": {},
				},
			},
		}
	},
	"anderson": {
		"name": "Anderson",
		"is_first_time": true,
		"dialog_tree": {
			"middle": {
				0: {
					"text": "Oi, eu sou o Anderson",
					"options": {}
				},
				1: {
					"text": "Dizem que eu sou o cara mais maneiro daqui", 
					"options": {
						0: {
							"text": "O que é esse disfarce seu?",
							"ignite": "ask_mask",
						},
						1: {
							"text": "*não comentar sobre o disfarce*",
							"ignite": "dont_ask",
						}
					}
				},
				2: {
					"text": "Bom, eu tenho negócios a fazer, te vejo alguma hora",
					"options": {}
				},
			},
			#fazer com que esses ignites tenham suas vertentes dentro deles
			"ask_mask": {
				"text": "Que disfarce? Não tô usando disfarce nenhum... (droga, ele percebeu)",
			},
			"dont_ask": {
				"text": "(ótimo, ele não suspeitou de nada)",
			},
			"exit": {
				"text": "...tenha um bom dia",
				"options": {}
			},
			"middle_done": {
				0: {
					"text": "*se disfançando*",
					"options": {},
				},
			},
		}
	},
	
	"grandma": {
		"name": "Vovó",
		"dialog_tree": {
			"is_first_time": true,
			"first_dialog": {
				"text": "hi",
				"options": {}
			},
			"middle": {
				0: {
					"text": "Oi pequenino",
					"options": {}
				},
				1: {
					"text": "Ouvi dizer que lá naquele templo tem umas plantas muito bonitas", 
					"options": {}
				},
				2: {
					"text": "Acho que você deveria olhar elas alguma hora",
					"options": {}
				},
			},
			"middle_done": {
				0: {
					"text": "Você já viu os corais do templo?",
					"options": {},
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
		"name": "Master",
		"is_first_time": true,
		"dialog_tree": {
			"middle": {
				0: {
					"text": "Olá garoto, parece que você veio conhecer a incrível arte do Baiacunismo, não é?",
					"options": {},
				},
				1: {
					"text": "Para isso, você terá que passar por algumas provações",
					"options": {},
				},
				2: {
					"text": "Só depois de se desapegar do que te segura neste mundo terreno…",
					"options": {},
				},
				3: {
					"text": "Talvez...",
					"options": {},
				},
				4: {
					"text": "...você consiga atingir o narvana...",
					"options": {},
				},
				5: {
					"text": "Ah, o que é o narvana?",
					"options": {},
				},
				6: {
					"text": "É tipo.... hmmm...",
					"options": {},
				},
				7: {
					"text": "...é tipo quando você chega em casa depois de um dia cansativo...",
					"options": {},
				},
				8: {
					"text": "...e troca pro pijama",
					"options": {},
				},
				9: {
					"text": "Difícil explicar, vamos pro que importa",
					"options": {},
				},
				10: {
					"text": "Primeiro você terá que se desfazer de algum de seus itens que você carrega",
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
				11: {
					"text": "Depois, é só atravessar a porta que irá surgir, que eu vou te ensinar tudo",
					"options": {},
				},
			},
			"middle_done": {
				0: {
					"text": "É só atravessar a porta, não tem segredo",
					"options": {},
				},
			},
			"function": {
				"status": "none",
				"text": "Do outro lado da porta, terá seu desafio",
				"id": "open_first_level_portal",
				"options": {},
			}
		}
	},
	
	"second_master": {
		"name": "Master",
		"is_first_time": true,
		"dialog_tree": {
			"middle": {
				0: {
					"text": "Espero que tenha passado na loja antes para comprar coisas para usar aqui",
					"options": {},
				},
				1: {
					"text": "Dessa vez, irá lutar contra suas relações passadas",
					"options": {},
				},
				2: {
					"text": "Sabe? Seus pais, sua ex namorada, suas relações de trabalho, e sua antiga banda",
					"options": {},
				},
				3: {
					"text": "Quer entrar agora?",
					"options": {
						0: {
							"text": "Sim",
							"ignite": "function",
						},
						1: {
							"text": "Não, preciso me preparar mais",
							"ignite": "exit",
						},
					},
				},
			},
			"middle_done": {
				0: {
					"text": "Quer entrar agora? Esperarei você do outro lado",
					"options": {
						0: {
							"text": "Sim",
							"ignite": "function"
						},
						1: {
							"text": "Não",
							"ignite": "exit"
						}
					},
				},
			},
			"function": {
				"status": "none",
				"text": "Espero que esteja pronto",
				"id": "open_second_level_portal",
				"options": {},
			},
			"exit": {
				"text": "Tudo bem, volte aqui quando precisar",
				"options": {}
			}
		}
	},
	
	"master_first_level": {
		"name": "Master",
		"is_first_time": true,
		"dialog_tree": {
			"middle": {
				0: {
					"text": "Você tem que bater nos seus apegos materiais assim como um padeiro sova uma massa",
					"options": {},
				},
				1: {
					"text": "Você pode começar testando naquele saco de batata no canto",
					"options": {},
				},
				2: {
					"text": "Quando você conseguir destruir ele, a porta vai abrir, e você vai enfrentar o desafio de verdade",
					"options": {},
				},
				3: {
					"text": "Mas lembre-se, você não deve descontar suas mágoas nesses apegos",
					"options": {},
				},
				4: {
					"text": "Você tem que retirá-los da sua vida, esquecê-los para não te afetarem mais",
					"options": {},
				},
				5: {
					"text": "Boa sorte, jovem. Vou estar te esperando para o próximo desafio",
					"options": {},
				},
				6: {
					"text": "*some*",
					"options": {},
				},
			},
			"middle_done": {
				0: {
					"text": "*está sumido*",
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
	
	"gardener": {
		"name": "Master",
		"is_first_time": true,
		"dialog_tree": {
			"middle": {
				0: {
					"text": "Olá garoto, parece que você veio conhecer a incrível arte do Baiacunismo, não é?",
					"options": {},
				},
				1: {
					"text": "Para isso, você terá que passar por algumas provações",
					"options": {},
				},
				2: {
					"text": "Só depois de se desapegar do que te segura neste mundo terreno…",
					"options": {},
				},
				3: {
					"text": "Talvez...",
					"options": {},
				},
				4: {
					"text": "...você consiga atingir o narvana...",
					"options": {},
				},
				5: {
					"text": "Ah, o que é o narvana?",
					"options": {},
				},
				6: {
					"text": "É tipo.... hmmm...",
					"options": {},
				},
				7: {
					"text": "...é tipo quando você chega em casa depois de um dia cansativo...",
					"options": {},
				},
				8: {
					"text": "...e troca pro pijama",
					"options": {},
				},
				9: {
					"text": "Difícil explicar, vamos pro que importa",
					"options": {},
				},
				10: {
					"text": "Primeiro você terá que se desfazer de algum de seus itens que você carrega",
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
				11: {
					"text": "Depois, é só atravessar a porta que irá surgir, que eu vou te ensinar tudo",
					"options": {},
				},
			},
			"middle_done": {
				0: {
					"text": "É só atravessar a porta, não tem segredo",
					"options": {},
				},
			},
			"function": {
				"status": "none",
				"text": "Do outro lado da porta, terá seu desafio",
				"id": "open_first_level_portal",
				"options": {},
			}
		}
	},
	"second_level_master": {
		"name": "Master",
		"is_first_time": true,
	},
	"third_level_master": {
		"name": "Master",
		"is_first_time": true,
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
