extends Area2D

func _ready():
	pass

func _on_haystack_body_entered( body ):
	if (body is preload("res://characters/wizard/wizard.gd")):
		$particles.amount = max(60, body.velocity.length() / 4)
		$particles.process_material.initial_velocity = max(100, body.velocity.length() / 3)
		$particles.emitting = true
		$particles.restart()
		body.is_in_haystack = true

func _on_haystack_body_exited( body ):
	if (body is preload("res://characters/wizard/wizard.gd")):
		body.is_in_haystack = false