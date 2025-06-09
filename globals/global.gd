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
			"i'm fine; i'm sad :(",
			"ok :D"
		],
		1: [
			"how's the weather?",
			"i hate you.",
			"oi;tchau;opt1: oieeee;opt2: byeee",
			":D"
		],
		2: [
			"disturbing the peace",
			"look into my eyes",
			"now tell me the things you were laughing about behind my back"
		]
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
