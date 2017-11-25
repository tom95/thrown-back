extends "res://characters/npc_bouncer.gd"

const COOLDOWN = 1000
const STONE_SPEED = 100
var stone_cooldown = 0
var attacking = null

onready var stone_spawn = get_node("base/stone_spawn")

func _ready():
	pass

func _process(delta):
	stone_cooldown = max(0, stone_cooldown - 1000 * delta)
	if attacking and stone_cooldown <= 0:
		throw_stone()

func throw_stone():
	stone_cooldown = COOLDOWN
	var projectile = preload("res://effects/stone/stone.tscn").instance()
	projectile.add_collision_exception_with(self)
	projectile.linear_velocity = (attacking.global_position - stone_spawn.global_position) * 2
	projectile.position = stone_spawn.global_position
	emit_signal("spawn", projectile)

func _on_attack_area_body_entered( body ):
	if (body is preload("res://characters/wizard/wizard.gd")):
		attacking = body

func _on_attack_area_body_exited( body ):
	if (body is preload("res://characters/wizard/wizard.gd")):
		attacking = null
