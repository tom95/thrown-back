extends Node2D

const FALLOFF = 50
const MAX_STRENGTH_BOUND = 150
const PUSH_FORCE = 1400

func emit():
	$particles.restart()
	for body in $influence_area.get_overlapping_bodies():
		var distance = global_position.distance_to(body.global_position)
		var strength = FALLOFF / max(distance, MAX_STRENGTH_BOUND)
		var direction = (body.global_position - global_position).normalized()
		if body.has_method("apply_impulse"):
			body.apply_impulse(Vector2(0,0), direction * strength * PUSH_FORCE)
