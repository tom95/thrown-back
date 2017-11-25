extends "res://characters/npc_bouncer.gd"

signal killed

func _ready():
	pass

func despawn():
	.despawn()
	emit_signal("killed")
