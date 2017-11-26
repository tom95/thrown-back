extends KinematicBody2D

signal spawn(object)

const MAX_VELOCITY = 200
const MAX_HEALTH = 10000

var health = MAX_HEALTH
var velocity = Vector2(0, 0)
var player
var target_position
var movement_area

func _ready():
	set_process(false)

func start_engaging(player, movement_area):
	set_process(true)
	self.player = player
	self.movement_area = movement_area
	$reposition_timer.start()
	next_turn()

func _process(delta):
	var to_go = target_position - global_position
	var factor = min(1, to_go.length () / MAX_VELOCITY)
	velocity = to_go.normalized() * 1000 * factor * delta
	move_and_collide(velocity)

func _on_reposition_timer_timeout():
	next_turn()

func take_damage(amount, dealer):
	health -= amount
	$reposition_timer.wait_time = lerp(2, 0.7, health / MAX_HEALTH)

func next_turn():
	target_position = random_position()

	var attack = randi() % 2
	if attack == 0:
		poison_ray()
	elif attack == 1:
		ice_ray()
	elif attack == 2:
		telekinesis_ray()

func random_position():
	return Vector2(
		rand_range(movement_area.position.x, movement_area.end.x),
		rand_range(movement_area.position.y, movement_area.end.y))

# attacks
func spawn_projectile(projectile, vel):
	projectile.add_collision_exception_with(self)
	projectile.linear_velocity = vel
	projectile.position = global_position
	emit_signal("spawn", projectile)

func ice_ray():
	spawn_projectile(preload("res://effects/icebolt/icebolt.tscn").instance(),
		(player.global_position - global_position) * 2)

const NUM_POISON_PROJECTILES = 5
const POISON_SPREAD = 5
const POISON_SPEED = 500
func poison_ray():
	var base_angle = -floor(NUM_POISON_PROJECTILES / 2)
	var base_vector = (player.global_position - global_position).normalized() * POISON_SPEED
	for i in range(NUM_POISON_PROJECTILES):
		var projectile = preload("res://effects/poison_ray/poison_ray.tscn").instance()
		projectile.damage_dealer_texture = $base/beholder.texture
		projectile.target_group = "players"
		spawn_projectile(projectile,
			base_vector.rotated(deg2rad((base_angle + i) * POISON_SPREAD)))

func telekinesis_ray():
	spawn_projectile(preload("res://effects/telekinesis_ray/telekinesis_ray.tscn").instance(),
		(player.global_position - global_position) * 2)


