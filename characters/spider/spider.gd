extends "res://characters/npc_bouncer.gd"

const DAMAGE = 100
const COOLDOWN = 2400
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
	linear_velocity =  Vector2(linear_velocity.x +(attackee.global_position.x - global_position.x), linear_velocity.y)

func _on_attack_area_body_entered( body ):
	if body.is_in_group("players"):
		attacking = true
		attackee = body

func _on_attack_area_body_exited( body ):
	if body.is_in_group("players"):
		attacking = false
		attackee = null

func _on_spider_body_entered( body ):
	if body.is_in_group("players"):
		body.take_damage(DAMAGE, $base/spider.texture)

func get_resource_path():
	return "res://characters/spider/spider.tscn"