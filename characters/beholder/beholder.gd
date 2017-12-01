extends KinematicBody2D

signal spawn(object)
signal update_boss_health(health)
signal killed
signal boss_killed

const MAX_VELOCITY = 200
const MAX_HEALTH = 10000

var health = MAX_HEALTH
var velocity = Vector2(0, 0)
var player
var target_position
var movement_area
var tween
var dead

func _ready():
	set_process(false)
	tween = Tween.new()
	add_child(tween)
	dead = false

func start_engaging(player, movement_area):
	set_process(true)
	self.player = player
	self.movement_area = movement_area
	update_reposition_timer()
	$reposition_timer.start()
	next_turn()

func _process(delta):
	var to_go = target_position - global_position
	var factor = min(1, to_go.length () / MAX_VELOCITY)
	velocity = to_go.normalized() * 1000 * factor * delta
	move_and_collide(velocity)

func _on_reposition_timer_timeout():
	next_turn()

func hit_by_firebolt():
	take_damage(250, null)

func take_damage(num, damage_dealer):
	if not dead:
		health -= num
		$reposition_timer.wait_time = max(lerp(1, 3, float(health) / MAX_HEALTH), 2)
		emit_signal("update_boss_health", health)
		update_reposition_timer()
		if health <= 0:
			despawn()

func despawn():
	dead = true
	if player.must_gravitate_to == self:
		player.must_gravitate_to = null
	emit_signal("killed")
	emit_signal("boss_killed")
	$reposition_timer.stop()

	var explosion = preload("res://effects/explosion/explosion.tscn").instance()
	explosion.global_position = global_position
	explosion.big_explosion()
	emit_signal("spawn", explosion)
	tween.interpolate_property(self, "scale", Vector2(1, 1), Vector2(0.1, 0.1), 0.5, Tween.TRANS_BACK, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_completed")

	queue_free()

func update_reposition_timer():
	$reposition_timer.wait_time = lerp(1, 3, float(health) / MAX_HEALTH)

func next_turn():
	if dead:
		return

	target_position = random_position()

	var health_percentage = float(health) /MAX_HEALTH
	var attack = randi() % 3
	if health_percentage >= 0.66:
		attack = 0
	elif health_percentage >= 0.33:
		attack = randi() % 2
	
	if attack == 0:
		poison_ray()
	elif attack == 1:
		petrifiation_ray()
	elif attack == 2:
		telekinesis_ray()

func random_position():
	return Vector2(
		rand_range(movement_area.position.x, movement_area.end.x),
		rand_range(movement_area.position.y, movement_area.end.y))

func projectile_spawn():
	return $projectile_spawn.global_position

# attacks
func spawn_projectile(projectile, vel):
	projectile.add_collision_exception_with(self)
	projectile.linear_velocity = vel
	projectile.position = projectile_spawn()
	emit_signal("spawn", projectile)

func petrifiation_ray():
	spawn_projectile(preload("res://effects/petrification/petrification.tscn").instance(),
		(player.global_position - projectile_spawn()) * 2)

const NUM_POISON_PROJECTILES = 5
const POISON_SPREAD = 5
const POISON_SPEED = 500
func poison_ray():
	var base_angle = -floor(NUM_POISON_PROJECTILES / 2)
	var base_vector = (player.global_position - projectile_spawn()).normalized() * POISON_SPEED
	for i in range(NUM_POISON_PROJECTILES):
		var projectile = preload("res://effects/poison_ray/poison_ray.tscn").instance()
		projectile.damage_dealer_texture = $base/beholder.texture
		projectile.target_group = "players"
		spawn_projectile(projectile,
			base_vector.rotated(deg2rad((base_angle + i) * POISON_SPREAD)))

const TELEKINESIS_SPEED = 300
func telekinesis_ray():
	var ray = preload("res://effects/telekinesis_ray/telekinesis_ray.tscn").instance()
	ray.velocity = (player.global_position - projectile_spawn()).normalized() * TELEKINESIS_SPEED
	ray.position = projectile_spawn()
	ray.gravitate_to = self
	emit_signal("spawn", ray)
