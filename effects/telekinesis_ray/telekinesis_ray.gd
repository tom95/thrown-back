extends Area2D

const DURATION = 1

var velocity = Vector2(0, 0)
var gravitate_to = null
var attached_to = null

func _ready():
	set_process(true)

func _process(delta):
	rotate(delta)
	if attached_to:
		position = attached_to.global_position
	else:
		translate(velocity * delta)

func _on_telekinesis_ray_body_entered(body):
	if body.is_in_group("players") and not body.must_gravitate_to:
		$timer.stop()
		attached_to = body
		body.must_gravitate_to = gravitate_to
		yield(get_tree().create_timer(DURATION), "timeout")
		body.must_gravitate_to = null
		queue_free()

func _on_timer_timeout():
	despawn()

func despawn():
	$particles.emitting = false
	yield(get_tree().create_timer(1), "timeout")
	queue_free()