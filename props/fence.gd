extends Area2D

const DAMAGE = 200

func _ready():
	pass

func _on_fence_body_entered( body ):
	if body is preload("res://characters/wizard/wizard.gd") or\
		body is preload("res://characters/npc_bouncer.gd"):
		body.take_damage(DAMAGE, $sprite.texture)