extends "res://scripts/components/BaseComponent.gd"

# This component initially was going to simply involve pressing all
# four lights, but because keyboards sometimes don't let you press
# multiple keys at once, now we just press the first two lights then
# the second two.

var pressed_lights: Array = []

func _ready() -> void:
	lights = [$Light1, $Light2, $Light3, $Light4]
	
	# Set light positions
	lights[1].position.x = Constants.LIGHT_DISTANCE_HORIZ
	lights[2].position.y = Constants.LIGHT_DISTANCE_VERT
	lights[3].position.x = Constants.LIGHT_DISTANCE_HORIZ
	lights[3].position.y = Constants.LIGHT_DISTANCE_VERT

func start() -> void:
	pressed_lights = []
	for light in lights:
		pressed_lights.append(false)
	lights[0].turn_on()
	lights[1].turn_on()

func press_light(light_num: int) -> void:
	lights[light_num].turn_off()
	if pressed_lights[light_num]:
		fail()
	elif (not pressed_lights[0]) or (not pressed_lights[1]):
		if light_num == 2 or light_num == 3:
			fail()
		else:
			pressed_lights[light_num] = true
			if pressed_lights[0] and pressed_lights[1]:
				lights[2].turn_on()
				lights[3].turn_on()
	else:
		pressed_lights[light_num] = true
		if pressed_lights[2] and pressed_lights[3]:
			deactivate()
		
func on_key_press(key: String) -> void:
	for i in range(len(lights)):
		if key == lights[i].key:
			press_light(i)
