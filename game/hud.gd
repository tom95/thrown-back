extends CanvasLayer

onready var fuel_meter = get_node("fuel_meter")
onready var player = get_node("../wizard")

func _ready():
	set_process(true)

func _process(delta):
	fuel_meter.value = player.jetpack_fuel
	fuel_meter.max_value = player.max_jetpack_fuel
