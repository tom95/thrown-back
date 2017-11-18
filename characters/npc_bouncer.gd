extends KinematicBody2D

const MAX_HEALTH = 1000
var health = 1000
const BOUNCING_BASELINE = 500
var velocity = Vector2()
const GRAVITY = Vector2(0, 1000.0)

func _ready():
	set_physics_process(true)
	
func _physics_process(delta):
	var old_velocity = velocity
	velocity += delta * GRAVITY
	velocity = move_and_slide(velocity, Vector2(0, -1), 25.0)
	
	if is_on_floor():
		velocity.y = - BOUNCING_BASELINE
		
func hit_by_firebolt():
	health = health - 250
	if (health <= 0):
		despawn()
		
func despawn():
	queue_free()