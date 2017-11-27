extends RigidBody2D

# things to customize
func life_time():
	return 2
func disable_particles():
	$particles.emitting = false
func should_stop_moving():
	return false


# interna
var dying = false

func _ready():
	contacts_reported = 5
	contact_monitor = true
	
	set_collision_mask_bit(0, true)
	set_collision_mask_bit(1, false)
	set_collision_layer_bit(0, false)
	set_collision_layer_bit(1, true)

	var timer = Timer.new()
	timer.set_name("expiry_timer")
	timer.wait_time = life_time()
	timer.autostart = true
	timer.connect("timeout", self, "_on_expiry_timer_timeout")
	add_child(timer)

func despawn():
	dying = true
	$collision.disabled = true
	disable_particles()
	if should_stop_moving():
		mode = MODE_STATIC

	$expiry_timer.wait_time = 1
	$expiry_timer.start()
	yield($expiry_timer, "timeout")
	queue_free()

func _on_expiry_timer_timeout():
	if not dying:
		despawn()