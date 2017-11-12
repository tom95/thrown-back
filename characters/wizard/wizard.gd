extends KinematicBody2D

const GRAVITY = Vector2(0, 1000.0)
const JETPACK_STRAFE_SPEED = 30.0
const JETPACK_SPEED = 40.0
const PROJECTILE_SPEED = 700
const MAX_JETPACK_FUEL = 100
const WEAPON_COOLDOWN =  200

var velocity = Vector2()
var jetpack_fuel = 100
var direction = 1
var weapon_cooldown = 0

onready var jetpack_exhaust = get_node("jetpack_exhaust")
onready var projectile_spawn = get_node("base/projectile_spawn")

func _ready():
	set_physics_process(true)
	velocity = Vector2(0, -1000)
	
func _physics_process(delta):
	var old_velocity = velocity
	velocity += delta * GRAVITY
	
	velocity = move_and_slide(velocity, Vector2(0, -1), 25.0)
	
	if is_on_floor():
		velocity.y = - max(min(old_velocity.y * 2, 1000), old_velocity.y * 0.8)
	
	var using_jetpack = Input.is_action_pressed("move_left") or\
		Input.is_action_pressed("move_right") or\
		Input.is_action_pressed("jump")

	if using_jetpack and can_use_jetpack():
		if Input.is_action_pressed("move_left"):
			velocity.x -= JETPACK_STRAFE_SPEED
		elif Input.is_action_pressed("move_right"):
			velocity.x += JETPACK_STRAFE_SPEED
		else:
			velocity.y -= JETPACK_SPEED * 20 if is_on_floor() else JETPACK_SPEED
		
		var drag_magnitude = velocity.length()
		var drag = -velocity.normalized() * (0.001 * drag_magnitude + 0.004 * drag_magnitude * drag_magnitude)
		drag.y = max(0, drag.y)
		velocity += drag * delta
		jetpack_exhaust.emitting = true
	else:
		jetpack_exhaust.emitting = false

	if using_jetpack:
		deplete_jetpack(delta)
	else:
		charge_jetpack(delta)

	weapon_cooldown = max(0, weapon_cooldown - 1000 * delta)
	
	if Input.is_action_pressed("move_left"):
		direction = -1
	elif Input.is_action_pressed("move_right"):
		direction = 1
	if Input.is_action_pressed("fire") and weapon_cooldown <= 0:
		weapon_cooldown = WEAPON_COOLDOWN
		var projectile = preload("res://effects/firebolt/firebolt.tscn").instance()
		projectile.add_collision_exception_with(self)
		projectile.linear_velocity = Vector2(PROJECTILE_SPEED * direction, 0)
		projectile.position = projectile_spawn.global_position
		get_parent().add_child(projectile)
	
func can_use_jetpack():
	return jetpack_fuel > 0

func deplete_jetpack(delta):
	jetpack_fuel = max(jetpack_fuel - delta * 100, 0)

func charge_jetpack(delta):
	jetpack_fuel = min(jetpack_fuel + delta * 75, MAX_JETPACK_FUEL)
