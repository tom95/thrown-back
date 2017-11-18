extends CanvasLayer

onready var fuel_meter = get_node("fuel_meter")
onready var health_bar = get_node("health_bar")
onready var player = get_node("../wizard")

func _ready():
	set_process(true)

func _process(delta):
	fuel_meter.value = player.jetpack_fuel
	fuel_meter.max_value = player.MAX_JETPACK_FUEL
	
	health_bar.value = player.health
	health_bar.max_value = player.MAX_HEALTH