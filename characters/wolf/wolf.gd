extends "res://characters/npc_bouncer.gd"

const COOLDOWN = 1000
const DAMAGE = 150
var attack_cooldown = 0
var attacking = false
var attackee = null
var direction = 1

func _ready():
	pass

func _process(delta):
	attack_cooldown = max(0, attack_cooldown - 1000 * delta)
	if attacking and attack_cooldown <= 0:
		attack()
	
	turn_to_direction_of_velocity()

func attack():
	attack_cooldown = COOLDOWN
	linear_velocity =  Vector2(linear_velocity.x + (attackee.global_position.x - global_position.x) * 5, linear_velocity.y + (attackee.global_position.y - global_position.y) * 5)

func _on_attack_area_body_entered( body ):
	if body.is_in_group("players"):
		attacking = true
		attackee = body

func _on_attack_area_body_exited( body ):
	if body.is_in_group("players"):
		attacking = false
		attackee = null

func _on_wolf_body_entered( body ):
	if body.is_in_group("players"):
		body.take_damage(DAMAGE, $base/wolf.texture)

func get_resource_path():
	return "res://characters/wolf/wolf.tscn"
