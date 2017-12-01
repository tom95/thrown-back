extends KinematicBody2D

const GRAVITY = Vector2(0, 1000.0)
const JETPACK_STRAFE_SPEED = 20.0
const JETPACK_SPEED = 40.0
const PROJECTILE_SPEED = 700
const MAX_JETPACK_FUEL = 100
const FIREBOLT_COOLDOWN =  600
const AIRBLAST_COOLDOWN = 600
const BOUNCING_BASELINE = 500
const MAX_HEALTH = 1000
#const MAX_VELOCITY = Vector2(1000, 1000)
#changed max_velocity for super jump; maybe use factor instead?
const MAX_VELOCITY = Vector2(1000, 2000)
const FLOOR_BOOST_FACTOR = 10
const MAX_FLOOR_ANGLE = deg2rad(46)
const TELEKINESIS_SPEED = 400

var gravity_scale = 1
var velocity = Vector2()
var jetpack_fuel = 100
var direction = 1
var firebolt_cooldown = 0
var airblast_cooldown = 0
var health = 1000
var is_in_godmode = false

var is_in_haystack = false
var is_on_floor = false
var is_on_ceiling = false
var is_on_wall = false
var is_iced = false
var is_petrified = false
var must_gravitate_to = null

onready var jetpack_exhaust = get_node("jetpack_exhaust")
onready var projectile_spawn = get_node("base/projectile_spawn")
onready var wizard_sprite = get_node("base")

signal killed(damage_dealer_image)

func _ready():
	set_physics_process(true)

func move_and_bounce(delta):
	var old_velocity = velocity
	velocity += delta * GRAVITY * gravity_scale
	is_on_floor = false
	is_on_ceiling = false
	is_on_wall = false

	var collision = move_and_collide(velocity * delta)
	if collision:
		is_on_floor = collision.normal.dot(Vector2(0, -1)) >= cos(MAX_FLOOR_ANGLE)
		if is_on_floor:
			$audio/bounce.play()
			velocity.y = -clamp(old_velocity.y * 0.8, BOUNCING_BASELINE, old_velocity.y * 2)
			# damp horizontal movement when we hit a slope
			velocity.x *= 1.0 - abs(collision.normal.angle_to(Vector2(0, -1))) / MAX_FLOOR_ANGLE
			if is_in_haystack:
				velocity.y = - 10 * sqrt(-velocity.y)
		else:
			is_on_ceiling = collision.normal.dot(Vector2(0, 1)) >= cos(MAX_FLOOR_ANGLE)
			if is_on_ceiling:
				velocity.y = 0
			else:
				is_on_wall = true
				velocity = (velocity * 0.2).bounce(collision.normal)

func _physics_process(delta):
	if is_iced:
		return

	if must_gravitate_to:
		var direction = (must_gravitate_to.global_position - global_position).normalized()
		move_and_collide(direction * TELEKINESIS_SPEED * delta)
	else:
		move_and_bounce(delta)

	if is_petrified:
		return

	var is_jumping = Input.is_action_pressed("jump")
	var is_strafing = Input.is_action_pressed("move_left") or\
		Input.is_action_pressed("move_right")

	var using_jetpack = is_strafing or is_jumping
	var strafing_and_jumping_penalty = 0.4

	if using_jetpack and can_use_jetpack():
		var strafe_speed = JETPACK_STRAFE_SPEED if not is_jumping else JETPACK_STRAFE_SPEED * strafing_and_jumping_penalty
		if Input.is_action_pressed("move_left"):
			velocity.x -= strafe_speed
		elif Input.is_action_pressed("move_right"):
			velocity.x += strafe_speed

		if is_jumping:
			velocity.y -= JETPACK_SPEED * FLOOR_BOOST_FACTOR if is_on_floor else JETPACK_SPEED

		apply_drag(delta)

		jetpack_exhaust.emitting = true
		if not $audio/levitation.playing:
			$audio/levitation.playing = true
	else:
		jetpack_exhaust.emitting = false
		$audio/levitation.playing = false

	if using_jetpack:
		var depletion = delta
		if is_jumping and is_strafing:
			depletion *= 1+ strafing_and_jumping_penalty
		deplete_jetpack(depletion)
	else:
		charge_jetpack(delta)
	
	elapse_cooldowns(delta)
	
	if Input.is_action_pressed("move_left"):
		direction = -1
	elif Input.is_action_pressed("move_right"):
		direction = 1
	wizard_sprite.scale.x = direction

	if Input.is_action_pressed("fire") and firebolt_cooldown <= 0:
		firebolt()

	if Input.is_action_pressed("airblast") and airblast_cooldown <= 0:
		airblast()

	velocity.x = clamp(-MAX_VELOCITY.x, velocity.x, MAX_VELOCITY.x)
	velocity.y = clamp(-MAX_VELOCITY.y, velocity.y, MAX_VELOCITY.y)

func take_damage(damage, damage_dealer_image):
	if is_in_godmode:
		return

	health = health - damage
	if (health <= 0):
		emit_signal("killed", damage_dealer_image)
	else:
		$audio/damage.get_node(str(randi() % 3 + 1)).play()

func super_jump(jump_factor):
	if velocity.y <= 0:
		velocity.y = velocity.y * -1

	velocity = Vector2(0, velocity.y * jump_factor)

func heal(num):
	health = min(MAX_HEALTH, health + num)

func hit_by_icebolt():
	if is_iced:
		return

	is_iced = true
	$base/wizard_iceBlock.set_visible(true)
	$base/ice_timer.wait_time = 1
	$base/ice_timer.start()

func _on_ice_timer_timeout():
	is_iced = false
	$base/wizard_iceBlock.set_visible(false)

func hit_by_petrification():
	if is_petrified:
		return

	is_petrified = true
	gravity_scale = 7
	velocity = Vector2(0,-100)
	$base/wizardbody.set_visible(false)
	$base/wizard_petrified.set_visible(true)
	$base/petrification_timer.wait_time = 2
	$base/petrification_timer.start()

func _on_petrification_timer_timeout():
	is_petrified = false
	gravity_scale = 1
	$base/wizardbody.set_visible(true)
	$base/wizard_petrified.set_visible(false)

func apply_drag(delta):
	var drag_magnitude = velocity.length()
	var drag = -velocity.normalized() * (0.001 * drag_magnitude + 0.004 * drag_magnitude * drag_magnitude)
	drag.y = max(0, drag.y)
	velocity += drag * delta

func firebolt():
	firebolt_cooldown = FIREBOLT_COOLDOWN
	var projectile = preload("res://effects/firebolt/firebolt.tscn").instance()
	projectile.add_collision_exception_with(self)
	projectile.linear_velocity = Vector2(PROJECTILE_SPEED * direction, 0)
	projectile.position = projectile_spawn.global_position
	get_parent().add_child(projectile)

func airblast():
	airblast_cooldown = AIRBLAST_COOLDOWN
	$base/projectile_spawn/airblast.emit()
	
func elapse_cooldowns(delta):
	firebolt_cooldown = max(0, firebolt_cooldown - 1000 * delta)
	airblast_cooldown = max(0, airblast_cooldown - 1000 * delta)

func can_use_jetpack():
	if is_in_godmode:
		return true

	return jetpack_fuel > 0

func deplete_jetpack(delta):
	jetpack_fuel = max(jetpack_fuel - delta * 100, 0)

func charge_jetpack(delta):
	jetpack_fuel = min(jetpack_fuel + delta * 75, MAX_JETPACK_FUEL)
