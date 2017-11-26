extends Node2D

func _ready():
	for character in $characters.get_children():
		connect_character_signals(character)

func connect_character_signals(character):
	character.connect("spawn", self, "_on_character_wants_spawn")

func _on_character_wants_spawn(object):
	add_child(object)

func get_spawn_position():
	return $spawn.global_position

func needs_light():
	return false