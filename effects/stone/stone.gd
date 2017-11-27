extends "res://effects/damaging_projectile.gd"

func get_damage(body):
	return 100

func disable_particles():
	pass

func _on_body_entered( body ):
	._on_body_entered( body )
	queue_free()