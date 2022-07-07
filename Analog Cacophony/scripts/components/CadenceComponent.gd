extends "res://scripts/components/BaseComponent.gd"

var outside_is_first: bool = false
var pressed: Array = []

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	lights = [$Light1, $Light2, $Light3]
	lights[1].position.x = Constants.LIGHT_DISTANCE_HORIZ
	lights[2].position.x = Constants.LIGHT_DISTANCE_HORIZ * 2

func start() -> void:
	pressed = [false, false, false]
	outside_is_first = rng.randi_range(0, 1) == 0
	if outside_is_first:
		lights[0].turn_on()
		lights[2].turn_on()
	else:
		lights[1].turn_on()

func on_key_press(key: String) -> void:
	
	for i in range(len(lights)):
		if key == lights[i].key:
			if outside_is_first and (not pressed[0] or not pressed[2]) and i == 1:
				for light in lights:
					light.turn_off()
				fail()
			elif not outside_is_first and (not pressed[1]) and (i == 0 or i == 2):
				for light in lights:
					light.turn_off()
				fail()
			else:
				lights[i].turn_off()
				pressed[i] = true
				
				if outside_is_first and pressed[0] and pressed[2]:
					lights[1].turn_on()
				elif not outside_is_first and pressed[1]:
					lights[0].turn_on()
					lights[2].turn_on()
	
	# Deactivate if everything is pressed
	for press in pressed:
		if not press:
			return
	
	for light in lights:
		light.turn_off()
	deactivate()
