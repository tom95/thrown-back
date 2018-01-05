extends Node2D

signal enemy_killed(type)

func _ready():
	for character in $characters.get_children():
		connect_character_signals(character)
	
func connect_character_signals(character):
	character.connect("spawn", self, "_on_character_wants_spawn")
	character.connect("enemy_killed", self, "_on_enemy_killed")

func _on_character_wants_spawn(object):
	add_child(object)
	
func _on_enemy_killed(type):
	emit_signal("enemy_killed", type)

func get_spawn_position():
	return $spawn.global_position

func get_boss_fight_position():
	return $boss_fight.global_position

func needs_light():
	return false