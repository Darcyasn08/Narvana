extends Node

var player_damage := 200
var player_can_attack: bool = false
var player_base_pos: Vector3 = Vector3(0,1,0)

var current_world
enum worlds {NORMAL, FIRST_LEVEL}

var cutscenes: Dictionary = {
	"start": false,
	"final": false
}

enum npcs {crab, master}

var dialogues: Dictionary = {
	"crab": {
		0: [
			"hello",
			"i am crab",
			"how are you?",
			"i'm fine; ...; that's good to hear!; ... okay...",
			"bye :)"
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
