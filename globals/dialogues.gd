extends Node

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
		"name": "Mestre",
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
	
	"master_end_first_level": {
		"name": "Mestre",
		"is_first_time": true,
		"dialog_tree": {
			"middle": {
				0: {
					"text": "Parabéns, você conseguiu terminar seu primeiro desafio",
					"options": {},
				},
				1: {
					"text": "Seu próximo objetivo, é lutar contra seus apegos emocionais",
					"options": {},
				},
				2: {
					"text": "No canto de uma das paredes do templo, você poderá trocar entre uma arma nova",
					"options": {},
				},
				3: {
					"text": "E depois, me encontre em algum lugar da vila, onde você terá seu segundo desafio",
					"options": {},
				},
				4: {
					"text": "Estarei te esperando",
					"options": {},
				},
			},
			"middle_done": {
				0: {
					"text": "A porta está logo ali, para você continaur sua jornada",
					"options": {},
				},
			},
			"function": {
				"status": "none",
				"text": "Espero que esteja pronto",
				"id": "open_second_level_portal",
				"options": {},
			},
		}
	},
	
	"second_master": {
		"name": "Mestre",
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
		"name": "Mestre",
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
		"name": "Jardineiro",
		"is_first_time": true,
		"dialog_tree": {
			"middle": {
				0: {
					"text": "A minha família tem cuidado desse templo por eras",
					"options": {},
				},
				1: {
					"text": "Às vezes, as pessoas me questionam",
					"options": {},
				},
				2: {
					"text": "'Ai, mas por que você continua cuidando daquele templo velho?'",
					"options": {},
				},
				3: {
					"text": "Mas eu até que gosto",
					"options": {},
				},
				4: {
					"text": "As plantas são minha parte favorita de cuidar",
					"options": {},
				},
			},
			"middle_done": {
				0: {
					"text": "Você também acha as plantas do templo bonitas?",
					"options": {},
				},
			},
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
