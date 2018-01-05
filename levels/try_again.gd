extends Node2D

const FIRST_LEVEL = "res://levels/01-grass/01-grass.tscn"
const SHOW_INSTRUCTIONS = false

func _ready():
	set_process(true)

func _process(delta):
	if Input.is_action_pressed("start"):
		print("a")
		var gamec = load("res://game/game.tscn")
		print("b")
		var game = gamec.instance()
		print("c")
		get_parent().add_child(game)
		print("d")
		game.show_level(FIRST_LEVEL)
		print("e")
		game.show_instructions(SHOW_INSTRUCTIONS)
		print("f")
		queue_free()
		print("z")