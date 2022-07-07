extends "res://scripts/components/BaseComponent.gd"

var direction_is_left: bool = false

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	lights = [$Light1, $Light2]
	lights[1].position.x = Constants.LIGHT_DISTANCE_HORIZ * 3

func start() -> void:
	lights[0].turn_on()
	lights[1].turn_on()
	direction_is_left = rng.randi_range(0, 1) == 0

func on_key_press(key: String) -> void:
	lights[0].turn_off()
	lights[1].turn_off()
	if direction_is_left and key == lights[0].key:
		deactivate()
	elif (not direction_is_left) and key == lights[1].key:
		deactivate()
	else:
		fail()
