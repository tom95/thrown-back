extends Node2D

const FALLOFF = 100
const PUSH_FORCE = 2000

func emit():
	$particles.restart()
	for body in $influence_area.get_overlapping_bodies():
		var distance = global_position.distance_to(body.global_position)
		var strength = FALLOFF / distance
		print(strength)
		var direction = (body.global_position - global_position).normalized()
		if body.has_method("add_force"):
			body.apply_impulse(Vector2(0,0), direction * strength * PUSH_FORCE)
