extends Node2D

const FIRST_LEVEL = "res://levels/01-grass/01-grass.tscn"

func _ready():
	set_process(true)

func _process(delta):
	if Input.is_action_pressed("fire"):
		var game = load("res://game/game.tscn").instance()
		get_parent().add_child(game)
		game.show_level(FIRST_LEVEL)
		queue_free()