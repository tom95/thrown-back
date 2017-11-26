extends Node2D

signal spawn(object)

func _ready():
	for character in $characters.get_children():
		connect_character_signals(character)

func connect_character_signals(character):
	character.connect("spawn", self, "_on_character_wants_spawn")

func _on_character_wants_spawn(object):
	# check if we are inside a game or if we are being run by ourselves
	if get_tree().get_root().get_child(0) == self:
		add_child(object)
	else:
		emit_signal("spawn", object)

func get_spawn_position():
	return $spawn.global_position

func needs_light():
	return false