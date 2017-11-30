extends "res://levels/level.gd"

const NEXT_LEVEL = "res://levels/01-grass/01-grass.tscn"
signal next_level(level)

func _ready():
	pass

func _on_training_end_body_entered( body ):
	emit_signal("next_level", NEXT_LEVEL)