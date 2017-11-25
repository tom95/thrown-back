extends Node2D

signal spawn(object)

func _ready():
	for character in $characters.get_children():
		connect_character_signals(character)

func connect_character_signals(character):
	character.connect("spawn", self, "_on_character_wants_spawn")

func _on_character_wants_spawn(object):
	emit_signal("spawn", object)
