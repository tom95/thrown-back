extends RigidBody2D

var dying = false

func _ready():
	set_process(true)

func _process(delta):
	pass

func _on_Timer_timeout():
	if dying:
		queue_free()
	else:
		despawn()

func despawn():
	dying = true
	$fire.emitting = false
	
	$timer.wait_time = 1
	$timer.start()
	
	$collision.disabled = true
	mode = MODE_STATIC

func _on_petrificatione_body_entered( body ):
	if not body.has_method("hit_by_petrification"):
		return
	
	body.call("hit_by_petrification")
	despawn()
	
	var sparkles = preload("res://effects/hit_marker/hit_marker.tscn").instance()
	sparkles.position = global_position
	sparkles.rotation = (-linear_velocity).angle()
	get_parent().add_child(sparkles)
