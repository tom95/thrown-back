extends "res://characters/npc_bouncer.gd"

const DAMAGE = 300
const ICE_COOLDOWN = 2000
const ICE_PROJECTILE_SPEED = 1000
var ice_cooldown = 0
var attacking = false

func _ready():
	pass

func _process(delta):
	ice_cooldown = max(0, ice_cooldown - 1000 * delta)
	if attacking and ice_cooldown <= 0:
		iceblast()

func iceblast():
	ice_cooldown = ICE_COOLDOWN
	
	var projectile = preload("res://effects/firebolt/firebolt.tscn").instance()
	projectile.add_collision_exception_with(self)
	projectile.linear_velocity = Vector2(ICE_PROJECTILE_SPEED, 0)
	projectile.position = $base/projectile_spawn.global_position
	get_parent().add_child(projectile)

func _on_icewisp_body_entered( body ):
	if (body is preload("res://characters/wizard/wizard.gd")):
		body.take_damage(DAMAGE)

func _on_detect_wizard_area_body_entered( body ):
	if (body is preload("res://characters/wizard/wizard.gd")):
		attacking = true

func _on_detect_wizard_area_body_exited( body ):
	if (body is preload("res://characters/wizard/wizard.gd")):
		attacking = false
