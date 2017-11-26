extends "res://characters/npc_bouncer.gd"

const DAMAGE = 300
const PETRIFICATION_COOLDOWN = 2200
const PETRIFICATION_SPEED = 3
var petrification_cooldown = 0
var attacking = false
var attackee = null
var direction = 1

func _ready():
	pass

func _process(delta):
	petrification_cooldown = max(0, petrification_cooldown - 1000 * delta)
	if attacking:
		if attackee.global_position.x - global_position.x > 0:
			direction = -1
		else:
			direction = 1
		$base/basilisk.scale.x = direction
		if petrification_cooldown <= 0:
			shoot_petrification()

func shoot_petrification():
	petrification_cooldown = PETRIFICATION_COOLDOWN
	var projectile = preload("res://effects/petrification/petrification.tscn").instance()
	projectile.add_collision_exception_with(self)
	projectile.linear_velocity = (attackee.global_position - $base/projectile_spawn.global_position) * PETRIFICATION_SPEED
	projectile.position = $base/projectile_spawn.global_position
	emit_signal("spawn", projectile)

func _on_basilisk_body_entered( body ):
	if body.is_in_group("players"):
		body.take_damage(DAMAGE, $base/basilisk.texture)

func _on_attack_area_body_entered( body ):
	if body.is_in_group("players"):
		attacking = true
		attackee = body

func _on_attack_area_body_exited( body ):
	if body.is_in_group("players"):
		attacking = false
		attackee = null
