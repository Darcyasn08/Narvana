extends Node

var player_damage := 200

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
