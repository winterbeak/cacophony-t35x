extends "res://scripts/components/BaseComponent.gd"

var direction_is_left: bool = false

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

onready var left_sound = $Left
onready var right_sound = $Right
onready var correct_sound = $Correct
const DIRECTION_VOLUME = -4
const CORRECT_VOLUME = -6

func _ready() -> void:
	rng.randomize()
	
	lights = [$Light1, $Light2]
	lights[1].position.x = Constants.LIGHT_DISTANCE_HORIZ * 3
	
	left_sound.volume_db = DIRECTION_VOLUME
	right_sound.volume_db = DIRECTION_VOLUME
	correct_sound.volume_db = CORRECT_VOLUME
	
	left_sound.position = Constants.LIGHT_CENTER
	right_sound.position = lights[1].position + Constants.LIGHT_CENTER
	correct_sound.position = Vector2(Constants.LIGHT_DISTANCE_HORIZ*2, Constants.LIGHT_CENTER_Y)

func start() -> void:
	lights[0].turn_on()
	lights[1].turn_on()
	direction_is_left = rng.randi_range(0, 1) == 0
	if direction_is_left:
		left_sound.play()
	else:
		right_sound.play()

func on_key_press(key: String) -> void:
	lights[0].turn_off()
	lights[1].turn_off()
	if direction_is_left and key == lights[0].key:
		correct_sound.play()
		deactivate()
	elif (not direction_is_left) and key == lights[1].key:
		correct_sound.play()
		deactivate()
	else:
		fail()
