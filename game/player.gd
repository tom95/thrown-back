extends KinematicBody2D

const GRAVITY = Vector2(0, 600.0)
const WALK_SPEED = 250.0
const JUMP_SPEED = 20.0
var velocity = Vector2()
var jetpack_fuel = 100
var max_jetpack_fuel = 100

func _ready():
	set_physics_process(true)
	
onready var jetpack_exhaust = get_node("jetpack_exhaust")

func _physics_process(delta):
	velocity += GRAVITY * delta
	velocity = move_and_slide(velocity, Vector2(0, -1), 25.0)
	
	var using_jetpack = false
	
	if Input.is_action_pressed("jump") and can_use_jetpack():
		# to lift up from group, apply extra boost
		velocity.y -= JUMP_SPEED * 20 if is_on_floor() else JUMP_SPEED
		using_jetpack = true
	
	var target_velocity = 0
	if Input.is_action_pressed("move_left"):
		if is_on_floor() or can_use_jetpack():
			target_velocity = -WALK_SPEED
		using_jetpack = not is_on_floor()
	elif Input.is_action_pressed("move_right"):
		if is_on_floor() or can_use_jetpack():
			target_velocity = WALK_SPEED
		using_jetpack = not is_on_floor()
	if using_jetpack:
		target_velocity *= 0.7
	
	# implement higher inertia when in the air
	velocity.x = lerp(velocity.x, target_velocity, 0.1)
	
	jetpack_exhaust.emitting = can_use_jetpack() and using_jetpack
	
	if using_jetpack:
		deplete_jetpack(delta)
	else:
		charge_jetpack(delta)

func can_use_jetpack():
	return jetpack_fuel > 0

func deplete_jetpack(delta):
	jetpack_fuel = max(jetpack_fuel - delta * 100, 0)

func charge_jetpack(delta):
	jetpack_fuel = min(jetpack_fuel + delta * 75, max_jetpack_fuel)