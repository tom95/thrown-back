extends Node2D

const FIRST_LEVEL = "res://levels/01-grass/01-grass.tscn"
const SHOW_INSTRUCTIONS = false

func _ready():
	set_process(true)

func _process(delta):
	if Input.is_action_pressed("start"):
		var game = load("res://game/game.tscn").instance()
		get_parent().add_child(game)
		game.show_level(FIRST_LEVEL)
		game.show_instructions(SHOW_INSTRUCTIONS)
		queue_free()