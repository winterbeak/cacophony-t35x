extends "res://scripts/components/BaseComponent.gd"

var pressed_lights: Array = []
var correct_light: int = 0
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	# Lights from left to right
	lights = [$Light1, $Light2, $Light3, $Light4]
	for i in range(len(lights)):
		lights[i].position.x = Constants.LIGHT_DISTANCE_HORIZ * i

func start() -> void:
	pressed_lights = []
	for light in lights:
		pressed_lights.append(false)
		light.turn_on()
	
	correct_light = rng.randi_range(0, 3)

func press_light(light_num: int) -> void:
	lights[light_num].turn_off()
	if pressed_lights[light_num]:
		fail()
	elif light_num == correct_light:
		deactivate()
	else:
		pressed_lights[light_num] = true

func on_key_press(key: String) -> void:
	for i in range(len(lights)):
		if key == lights[i].key:
			press_light(i)
