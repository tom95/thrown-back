extends "res://characters/npc_bouncer.gd"

const COOLDOWN = 1000
const DAMAGE = 100
var attack_cooldown = 0
var attacking = false
var attackee = null

func _ready():
	pass

func _process(delta):
	attack_cooldown = max(0, attack_cooldown - 1000 * delta)
	if attacking and attack_cooldown <= 0:
		attack()

func attack():
	attack_cooldown = COOLDOWN
	linear_velocity =  Vector2(linear_velocity.x + (attackee.global_position.x - global_position.x) * 2, linear_velocity.y + (attackee.global_position.y - global_position.y) * 2)

func _on_evilbat_body_entered( body ):
	if body.is_in_group("players"):
		body.take_damage(DAMAGE, $base/evilbat.texture)

func _on_attack_area_body_entered( body ):
	if body.is_in_group("players"):
		attacking = true
		attackee = body

func _on_attack_area_body_exited( body ):
	if body.is_in_group("players"):
		attacking = false
		attackee = null

func get_resource_path():
	return "res://characters/bat/evilbat.tscn"