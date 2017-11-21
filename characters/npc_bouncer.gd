extends RigidBody2D

const MAX_HEALTH = 1000
var health = 1000
const BOUNCING_BASELINE = 500
var velocity = Vector2()
const GRAVITY = Vector2(0, 1000.0)

func _ready():
	pass

func _integrate_forces(state):
	for i in range (state.get_contact_count()):
		if (state.get_contact_local_normal(i).dot(Vector2(0, -1))):
			var velocity_x = get_linear_velocity().x
			set_linear_velocity(Vector2(velocity_x, -BOUNCING_BASELINE))
		
func hit_by_firebolt():
	health = health - 250
	if (health <= 0):
		despawn()
		
func despawn():
	queue_free()