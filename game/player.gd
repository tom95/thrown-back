extends KinematicBody2D

const GRAVITY = Vector2(0, 1200.0)
const WALK_SPEED = 250.0
const JETPACK_STRAFE_SPEED = 30.0
const JETPACK_SPEED = 40.0
var velocity = Vector2()
var jetpack_fuel = 100
var max_jetpack_fuel = 100

onready var jetpack_exhaust = get_node("jetpack_exhaust")

var jetpacking = Jetpacking.new(self)
var walking = Walking.new(self)
var idle = Idle.new(self)

var current_state = idle

class State:
	var player
	func _init(p):
		player = p
	func enter():
		player.current_state.leave()
		player.current_state = self
	func process(delta):
		pass
	func leave():
		pass
	func check_leave():
		pass

class Idle extends State:
	func _init(p).(p):
		pass
	func check_leave():
		if Input.is_action_pressed("jump") and player.can_use_jetpack():
			player.jetpacking.enter()
		elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
			player.walking.enter()

class Jetpacking extends State:
	func _init(p).(p):
		pass
	func process(delta):
		var target_velocity = 0
		var using_jetpack = Input.is_action_pressed("move_left") or\
			Input.is_action_pressed("move_right") or\
			Input.is_action_pressed("jump")
		
		if player.can_use_jetpack() and using_jetpack:
			if Input.is_action_pressed("move_left"):
				player.velocity.x -= JETPACK_STRAFE_SPEED
			elif Input.is_action_pressed("move_right"):
				player.velocity.x += JETPACK_STRAFE_SPEED
			if Input.is_action_pressed("jump"):
				player.velocity.y -= JETPACK_SPEED * 20 if player.is_on_floor() else JETPACK_SPEED
		
		var drag_magnitude = player.velocity.length()
		var drag = -player.velocity.normalized() * (0.001 * drag_magnitude + 0.004 * drag_magnitude * drag_magnitude)
		drag.y = max(0, drag.y)
		player.velocity += drag * delta
		
		player.jetpack_exhaust.emitting = player.can_use_jetpack() and using_jetpack
		
		if using_jetpack:
			player.deplete_jetpack(delta)
		else:
			player.charge_jetpack(delta)
	
	func leave():
		player.jetpack_exhaust.emitting = false
	
	func check_leave():
		if player.is_on_floor():
			player.walking.enter()

class Walking extends State:
	func _init(p).(p):
		pass
	func process(delta):
		var target_velocity = 0
		if Input.is_action_pressed("move_left"):
			target_velocity = -WALK_SPEED
		elif Input.is_action_pressed("move_right"):
			target_velocity = WALK_SPEED
		player.velocity.x = lerp(player.velocity.x, target_velocity, 0.1)
		
		player.charge_jetpack(delta)
	
	func check_leave():
		if Input.is_action_pressed("jump") and player.can_use_jetpack():
			player.jetpacking.enter()

func _ready():
	set_physics_process(true)

func _physics_process(delta):
	velocity += GRAVITY * delta
	velocity = move_and_slide(velocity, Vector2(0, -1), 25.0)
	
	current_state.check_leave()
	current_state.process(delta)

func can_use_jetpack():
	return jetpack_fuel > 0

func deplete_jetpack(delta):
	jetpack_fuel = max(jetpack_fuel - delta * 100, 0)

func charge_jetpack(delta):
	jetpack_fuel = min(jetpack_fuel + delta * 75, max_jetpack_fuel)