extends "res://scripts/components/BaseComponent.gd"

var current_light = 0

func _ready() -> void:
	lights = [$Light1, $Light2]
	lights[1].position.x = Constants.LIGHT_DISTANCE_HORIZ

func start() -> void:
	lights[0].turn_on()
	current_light = 0

func on_key_press(key: String) -> void:
	if key != lights[current_light % 2].key:
		fail()
	else:
		lights[current_light % 2].turn_off()
		current_light += 1
		if current_light == 4:
			deactivate()
		else:
			lights[current_light % 2].turn_on()
