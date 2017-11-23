extends Area2D

func _ready():
	pass

func _on_haystack_body_entered( body ):
	if (body is preload("res://characters/wizard/wizard.gd")):
		body.is_in_haystack = true

func _on_haystack_body_exited( body ):
	if (body is preload("res://characters/wizard/wizard.gd")):
		body.is_in_haystack = false