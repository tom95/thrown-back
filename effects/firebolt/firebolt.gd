extends RigidBody2D

var dying = false

func _ready():
	set_process(true)

	set_collision_layer_bit(0, false)
	set_collision_layer_bit(1, true)

	set_collision_mask_bit(0, true)
	set_collision_mask_bit(1, false)

	$cast.play()

func _process(delta):
	pass

func _on_Timer_timeout():
	if dying:
		queue_free()
	else:
		despawn()

func despawn():
	dying = true
	$smoke.emitting = false
	$fire.emitting = false
	$collision.disabled = true

	$hit.play()

	$timer.wait_time = 1
	$timer.start()

	mode = MODE_STATIC

func _on_firebolt_body_entered(body):
	if not body.has_method("hit_by_firebolt"):
		return

	body.call("hit_by_firebolt")
	despawn()

	var sparkles = preload("res://effects/hit_marker/hit_marker.tscn").instance()
	sparkles.position = global_position
	sparkles.rotation = (-linear_velocity).angle()
	get_parent().add_child(sparkles)
