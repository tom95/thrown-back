extends "res://characters/npc_bouncer.gd"

signal cow_killed

func _ready():
	pass

func despawn():
	.despawn()
	emit_signal("cow_killed")

func get_resource_path():
	return "res://characters/cow/cow.tscn"