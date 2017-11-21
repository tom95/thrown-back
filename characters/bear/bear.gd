extends "res://characters/npc_bouncer.gd"
const DAMAGE = 250

func _ready():
	pass

func _on_bear_body_entered( body ):
	if (body is preload("res://characters/wizard/wizard.gd")):
		body.take_damage(DAMAGE)