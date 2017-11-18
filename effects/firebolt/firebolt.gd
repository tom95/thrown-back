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
		dying = true
		get_node("smoke").emitting = false
		get_node("fire").emitting = false
		
		var timer = get_node("timer")
		timer.start()
		timer.wait_time = 1

func _on_firebolt_body_entered( body ):
	if (body.has_method("hit_by_firebolt")):
		body.call("hit_by_firebolt")
		queue_free()