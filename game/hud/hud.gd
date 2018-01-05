extends CanvasLayer

onready var player = get_node("../wizard")

func _ready():
	set_process(true)

func _process(delta):
	$hud/fuel_meter.value = player.jetpack_fuel
	$hud/fuel_meter.max_value = player.MAX_JETPACK_FUEL
	
	$hud/health_bar.value = player.health
	$hud/health_bar.max_value = player.MAX_HEALTH
	
func _on_boss_fight_started(max_health):
	$hud/boss_health_bar.show()
	$hud/boss_health_bar.max_value = max_health
	$hud/boss_health_bar.value = max_health

func _on_boss_health_updated(value):
	$hud/boss_health_bar.value = value

func _on_cow_killed(num):
	$cow_counter.visible = true
	$cow_counter/counter.text = String(num)