extends RigidBody2D

const DAMAGE = 100
var has_hit = false

func _on_Timer_timeout():
	queue_free()

func _on_damage_area_body_entered( body ):
	if body.is_in_group("players") and not has_hit:
		has_hit = true
		body.take_damage(DAMAGE, $stone.texture)
