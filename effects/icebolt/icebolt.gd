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
	
	mode = MODE_STATIC

func _on_icebolt_body_entered(body):
	if not body.has_method("hit_by_icebolt"):
		return
	
	body.call("hit_by_icebolt")
	despawn()
	
	var sparkles = preload("res://effects/hit_marker/hit_marker.tscn").instance()
	sparkles.position = global_position
	sparkles.rotation = (-linear_velocity).angle()
	get_parent().add_child(sparkles)