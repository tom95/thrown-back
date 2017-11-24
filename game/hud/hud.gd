extends CanvasLayer

onready var player = get_node("../wizard")

func _ready():
	set_process(true)
	
	player.connect("update_cow_counter", self, "update_cow_counter")
	player.connect("game_over", self, "game_over")

func _process(delta):
	$fuel_meter.value = player.jetpack_fuel
	$fuel_meter.max_value = player.MAX_JETPACK_FUEL
	
	$health_bar.value = player.health
	$health_bar.max_value = player.MAX_HEALTH

func update_cow_counter(num):
	$cow_counter.visible = true
	$cow_counter/counter.text = String(num)
	
func game_over():
	print("GAME OVER!!!!!")