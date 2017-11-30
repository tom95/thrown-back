extends RigidBody2D

const JUMP_FACTOR = 42
const COOLDOWN = 800
var cooldown = 0
var is_active = true

func _ready():
	activate()

func _process(delta):
	cooldown = max(0, cooldown - 1000 * delta)

func activate():
	is_active = true
	$base/superjump_deactivated.visible = false

func deactivate():
	is_active = false
	$base/superjump_deactivated.visible = true

func _on_jump_area_body_entered( body ):
	#if body.has_method("super_jump(jump_factor)") and cooldown <= 0:
	if body.is_in_group("players") and cooldown <= 0 and is_active:
		cooldown = COOLDOWN
		body.super_jump(JUMP_FACTOR)
	
