extends KinematicBody2D

const GRAVITY = Vector2(0, 1000.0)
const JETPACK_STRAFE_SPEED = 20.0
const JETPACK_SPEED = 40.0
const PROJECTILE_SPEED = 700
const MAX_JETPACK_FUEL = 100
const WEAPON_COOLDOWN =  200
const BOUNCING_BASELINE = 500
const MAX_HEALTH = 1000
const MAX_VELOCITY = Vector2(1000, 1000)
const FLOOR_BOOST_FACTOR = 10
const MAX_FLOOR_ANGLE = deg2rad(30)

var velocity = Vector2()
var jetpack_fuel = 100
var direction = 1
var weapon_cooldown = 0
var health = 1000

var is_in_haystack = false
var is_on_floor = false
var is_on_ceiling = false
var is_on_wall = false
var is_iced = false

onready var jetpack_exhaust = get_node("jetpack_exhaust")
onready var projectile_spawn = get_node("base/projectile_spawn")
onready var wizard_sprite = get_node("base")

signal killed()

func _ready():
	set_physics_process(true)

func move_and_bounce(delta):
	var old_velocity = velocity
	velocity += delta * GRAVITY
	is_on_floor = false
	is_on_ceiling = false
	is_on_wall = false

	var collision = move_and_collide(velocity * delta)
	if collision:
		is_on_floor = collision.normal.dot(Vector2(0, -1)) >= cos(MAX_FLOOR_ANGLE)
		if is_on_floor:
			velocity.y = -clamp(old_velocity.y * 0.8, BOUNCING_BASELINE, old_velocity.y * 2)
			if is_in_haystack:
				velocity.y = - 10 * sqrt(-velocity.y)
		else:
			is_on_ceiling = collision.normal.dot(Vector2(0, 1)) >= cos(MAX_FLOOR_ANGLE)
			if is_on_ceiling:
				velocity.y = 0
			else:
				is_on_wall = true
				velocity = (velocity * 0.4).bounce(collision.normal)

func _physics_process(delta):
	if is_iced:
		return
	
	move_and_bounce(delta)

	var using_jetpack = Input.is_action_pressed("move_left") or\
		Input.is_action_pressed("move_right") or\
		Input.is_action_pressed("jump")

	if using_jetpack and can_use_jetpack():
		if Input.is_action_pressed("move_left"):
			velocity.x -= JETPACK_STRAFE_SPEED
		elif Input.is_action_pressed("move_right"):
			velocity.x += JETPACK_STRAFE_SPEED
		else:
			velocity.y -= JETPACK_SPEED * FLOOR_BOOST_FACTOR if is_on_floor else JETPACK_SPEED

		apply_drag(delta)

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
	wizard_sprite.scale.x = direction

	if Input.is_action_pressed("fire") and weapon_cooldown <= 0:
		shoot()
	
	if Input.is_action_pressed("airblast") and weapon_cooldown <= 0:
		airblast()

	velocity.x = clamp(-MAX_VELOCITY.x, velocity.x, MAX_VELOCITY.x)
	velocity.y = clamp(-MAX_VELOCITY.y, velocity.y, MAX_VELOCITY.y)

func take_damage(damage):
	health = health - damage
	if (health <= 0):
		emit_signal("killed")

func hit_by_icebolt():
	is_iced = true
	$base/wizard_iceBlock.set_visible(true)
	$base/ice_timer.wait_time = 1
	$base/ice_timer.start()

func _on_ice_timer_timeout():
	is_iced = false
	$base/wizard_iceBlock.set_visible(false)

func apply_drag(delta):
	var drag_magnitude = velocity.length()
	var drag = -velocity.normalized() * (0.001 * drag_magnitude + 0.004 * drag_magnitude * drag_magnitude)
	drag.y = max(0, drag.y)
	velocity += drag * delta

func shoot():
	weapon_cooldown = WEAPON_COOLDOWN
	var projectile = preload("res://effects/firebolt/firebolt.tscn").instance()
	projectile.add_collision_exception_with(self)
	projectile.linear_velocity = Vector2(PROJECTILE_SPEED * direction, 0)
	projectile.position = projectile_spawn.global_position
	get_parent().add_child(projectile)

func airblast():
	weapon_cooldown = WEAPON_COOLDOWN
	$base/projectile_spawn/airblast.emit()

func can_use_jetpack():
	return jetpack_fuel > 0

func deplete_jetpack(delta):
	jetpack_fuel = max(jetpack_fuel - delta * 100, 0)

func charge_jetpack(delta):
	jetpack_fuel = min(jetpack_fuel + delta * 75, MAX_JETPACK_FUEL)
