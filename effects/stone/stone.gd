extends "res://effects/damaging_projectile.gd"

func get_damage(body):
	return 100

func disable_particles():
	pass

func _on_body_entered( body ):
	._on_body_entered( body )
	var particles = preload("res://effects/stone/stone_breaking.tscn").instance()
	particles.position = global_position
	# FIXME get_parent().add_child is not pretty
	get_parent().add_child(particles)
	queue_free()