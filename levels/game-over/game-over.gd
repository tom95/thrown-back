extends Node2D

func _ready():
	var size = get_viewport().size

	randomize()
	$wizard.linear_velocity = Vector2(300, 0).rotated(rand_range(0, 2 * PI))
	$wizard.position = Vector2(rand_range(0, size.x), rand_range(0, size.y))

func set_killed_by(texture):
	$game_over_text/damage_dealer.texture = texture
	$game_over_text/damage_dealer.position.y += texture.get_height() / 2