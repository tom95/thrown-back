extends "res://effects/expiring_projectile.gd"

# set these on spawn
var target_group = null
var damage_dealer_texture = null

# customize in your subclass
func get_damage(body):
	return 200

func _ready():
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body):
	if target_group and body.is_in_group(target_group):
		body.take_damage(get_damage(body), damage_dealer_texture)
		despawn()