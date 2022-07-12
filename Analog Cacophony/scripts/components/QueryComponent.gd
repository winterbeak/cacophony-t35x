extends "res://scripts/components/BaseComponent.gd"

var pressed_lights: Array = []
var correct_light: int = 0
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

onready var wrong_query_sound = $C
onready var right_query_sound = $Correct
onready var activate_sound = $Activate
const WRONG_QUERY_VOLUME: int = -10
const RIGHT_QUERY_VOLUME: int = -10
const ACTIVATE_VOLUME: int = -10

func _ready() -> void:
	rng.randomize()
	
	activate_sound.volume_db = ACTIVATE_VOLUME
	wrong_query_sound.volume_db = WRONG_QUERY_VOLUME
	right_query_sound.volume_db = RIGHT_QUERY_VOLUME
	
	activate_sound.position.x = Constants.LIGHT_DISTANCE_HORIZ*2 + Constants.LIGHT_CENTER_X
	activate_sound.position.y = Constants.LIGHT_CENTER_Y
	wrong_query_sound.position.y = Constants.LIGHT_CENTER_Y
	right_query_sound.position.y = Constants.LIGHT_CENTER_Y
	
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
	
	activate_sound.play()

func press_light(light_num: int) -> void:
	lights[light_num].turn_off()
	if pressed_lights[light_num]:
		fail()
	elif light_num == correct_light:
		deactivate()
		right_query_sound.position.x = light_num*Constants.LIGHT_DISTANCE_HORIZ + Constants.LIGHT_CENTER_X
		right_query_sound.play()
	else:
		pressed_lights[light_num] = true
		wrong_query_sound.position.x = light_num*Constants.LIGHT_DISTANCE_HORIZ + Constants.LIGHT_CENTER_X
		wrong_query_sound.play()

func on_key_press(key: String) -> void:
	for i in range(len(lights)):
		if key == lights[i].key:
			press_light(i)
