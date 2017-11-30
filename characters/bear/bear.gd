extends "res://characters/npc_bouncer.gd"
const DAMAGE = 250

func _ready():
	pass

func _on_bear_body_entered( body ):
	if body.is_in_group("players"):
		body.take_damage(DAMAGE, $bear.texture)

func get_resource_path():
	return "res://characters/bear/bear.tscn"