extends Area2D

const DAMAGE = 200

func _ready():
	pass

func _on_fence_body_entered( body ):
	if body.is_in_group("characters"):
		body.take_damage(DAMAGE, $sprite.texture)