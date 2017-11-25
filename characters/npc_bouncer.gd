extends RigidBody2D

const MAX_HEALTH = 1000
var health = 1000
const BOUNCING_BASELINE = 500
var velocity = Vector2()
const GRAVITY = Vector2(0, 1000.0)
const MAX_FLOOR_ANGLE = deg2rad(5)

var tween

signal spawn(object)

func _ready():
	contact_monitor = true
	contacts_reported = 5
	mode = MODE_CHARACTER

	tween = Tween.new()
	add_child(tween)

func _integrate_forces(state):
	for i in range (state.get_contact_count()):
		if not state.get_contact_collider_object(i):
			continue
		# Should be line below, which does not work for some reason
		var shouldJump = state.get_contact_collider_object(i).has_method('get_cell_size')
		#var shouldJump = state.get_contact_collider_object(i).get_type()
		if (state.get_contact_local_normal(i).dot(Vector2(0, -1)) >= cos(MAX_FLOOR_ANGLE) and shouldJump):
			var velocity_x = get_linear_velocity().x
			set_linear_velocity(Vector2(velocity_x, -BOUNCING_BASELINE))

func hit_by_firebolt():
	health = health - 250
	if (health <= 0):
		despawn()

func despawn():
	var explosion = preload("res://effects/explosion/explosion.tscn").instance()
	explosion.global_position = global_position
	emit_signal("spawn", explosion)
	$collision.disabled = true
	set_process(false)
	set_physics_process(false)
	tween.interpolate_property(self, "scale", Vector2(1, 1), Vector2(0.1, 0.1), 0.5, Tween.TRANS_BACK, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_completed")
	queue_free()
