extends Node

var player_can_move: bool = true
var player_damage := 200.0
var dust_damage := 1500.0
var player_can_attack: bool = true
var player_base_pos: Vector3 = Vector3(0,5,0)



var enemies = [
	["res://scenes/enemies/coin.tscn","res://scenes/enemies/pig_bank.tscn","res://scenes/enemies/car.tscn", "res://scenes/enemies/pearl_collar.tscn"] #uma fase
]

var dead_enemies_first_level = [
	[0, 0],
	[0, 0],
	[0, 0],
	[0, 0],
]

var current_weapon: String = "bat"

var current_room: int = 0
var current_world: int
enum worlds {NORMAL, FIRST_LEVEL}

var completed_levels: Dictionary = {
	"first_level": false,
	"second_level": false,
	"third_level": false
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

var dialogues: Dictionary = {
	"crab": {
		0: [
			"hello",
			"i am crab",
			"how are you?",
			"i'm fine; i'm sad :(",
			"ok :D"
		],
	},
	
	"master": {
		0: [
			"hello little one",
			"i wonder what brings you here...",
			"oh!",
			"have you just come here to escape your old damn life?"
		],
	},
	
	"jellyfish": {
		0: [
			"vamo rir vamo rir",
			"vamo rir, daniel, vamo rir",
			"muahahaHAHAHAHAH"
		],
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
