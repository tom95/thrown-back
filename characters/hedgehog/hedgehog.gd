extends "res://characters/npc_bouncer.gd"

const DAMAGE = 150
var enemy = null
var direction = 1

func _ready():
	pass

func _process(delta):
	if enemy:
		if enemy.global_position.x - global_position.x > 0:
			direction = 1
		else:
			direction = -1
		$base/hedgehog.scale.x = direction

func _on_damage_area_body_entered( body ):
	if body.is_in_group("players"):
		body.take_damage(DAMAGE, $base/hedgehog.texture)


func _on_trigger_area_body_entered( body ):
	if body.is_in_group("players"):
		enemy = body


func _on_trigger_area_body_exited( body ):
	if body.is_in_group("players"):
		enemy = null

func get_resource_path():
	return "res://characters/hedgehog/hedgehog.tscn"