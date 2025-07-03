extends Node

var player_can_move: bool = true
var player_damage := 200.0
var dust_damage := 1500.0
var player_can_attack: bool = true
var player_base_pos: Vector3 = Vector3(0,5,0)



var enemies = [
	["res://scenes/coin.tscn","res://scenes/pig_bank.tscn"] #uma fase
]

var dead_enemies_first_level = [
	[0, 0],
	[0, 0]
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
				"options": {}
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
		},
		"jellyfish": {},
		"grandma": {},
	}
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
