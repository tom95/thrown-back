extends Area2D

const DAMAGE = 200

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _on_fence_body_entered( body ):

	if (body is preload("res://characters/wizard/wizard.gd")):
		body.take_damage(DAMAGE)