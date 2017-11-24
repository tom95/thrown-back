extends Node2D

const AREA_LENGTH = 700
const PUSH_FORCE = 2000

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func emit():
	$particles.restart()
	for body in $influence_area.get_overlapping_bodies():
		var distance = global_position.distance_to(body.global_position)
		var strength = distance / AREA_LENGTH
		var direction = (body.global_position - global_position).normalized()
		if body.has_method("add_force"):
			body.add_force(Vector2(0,0), direction * strength * PUSH_FORCE)
