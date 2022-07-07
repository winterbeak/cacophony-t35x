extends "res://scripts/components/BaseComponent.gd"

var volume: int = 3
const START_VOLUME: int = 3
const GOAL_VOLUME: int = 6
const FAIL_VOLUME: int = 0
var first_key_is_volume_up: bool = true

func _ready() -> void:
	lights = [$Light1, $Light2]
	lights[1].position.x = Constants.LIGHT_DISTANCE_VERT

func start() -> void:
	first_key_is_volume_up = not first_key_is_volume_up
	volume = START_VOLUME
	lights[0].turn_on()
	lights[1].turn_on()

func increase_volume() -> void:
	volume += 1
	if volume == GOAL_VOLUME:
		lights[0].turn_off()
		lights[1].turn_off()
		deactivate()

func decrease_volume() -> void:
	volume -= 1
	if volume == FAIL_VOLUME:
		fail()

func on_key_press(key: String) -> void:
	if key == lights[0].key:
		if first_key_is_volume_up:
			increase_volume()
		else:
			decrease_volume()
	elif key == lights[1].key:
		if not first_key_is_volume_up:
			increase_volume()
		else:
			decrease_volume()
