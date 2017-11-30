extends "res://characters/npc_bouncer.gd"

const DAMAGE = 120
const COOLDOWN = 1000
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
	
	if linear_velocity.x > 0:
		direction = -1
	else:
		direction = 1
	$base/farmer.scale.x = direction

func attack():
	if (randi() % 2) == 0:
		throw_stone()
	else:
		 sprint_attack()

func throw_stone():
	attack_cooldown = COOLDOWN
	var projectile = preload("res://effects/stone/stone.tscn").instance()
	projectile.add_collision_exception_with(self)
	projectile.target_group = "players"
	projectile.linear_velocity = (attackee.global_position - $base/stone_spawn.global_position) * 2.6
	projectile.position = $base/stone_spawn.global_position
	emit_signal("spawn", projectile)

func sprint_attack():
	attack_cooldown = COOLDOWN
	linear_velocity = Vector2(linear_velocity.x +(attackee.global_position.x - global_position.x), linear_velocity.y)*1.2

func _on_attack_area_body_entered( body ):
	if body.is_in_group("players"):
		attacking = true
		attackee = body


func _on_attack_area_body_exited( body ):
	if body.is_in_group("players"):
		attacking = false
		attackee = null


func _on_farmer_body_entered( body ):
	if body.is_in_group("players"):
		body.take_damage(DAMAGE, $base/farmer.texture)
