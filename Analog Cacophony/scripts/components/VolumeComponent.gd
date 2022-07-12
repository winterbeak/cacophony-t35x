extends "res://scripts/components/BaseComponent.gd"

var volume: int = 3
const START_VOLUME: int = 3
const GOAL_VOLUME: int = 6
const FAIL_VOLUME: int = 0
var first_key_is_volume_up: bool = true

onready var guitar_c = $C
onready var guitar_g = $G
onready var guitar_chord = $Chord
const GUITAR_VOLUME_STEP = 3
const GUITAR_VOLUME = -2

func _ready() -> void:
	lights = [$Light1, $Light2]
	lights[1].position.x = Constants.LIGHT_DISTANCE_HORIZ
	guitar_c.position.x = Constants.LIGHT_DISTANCE_HORIZ
	guitar_chord.position.x = Constants.LIGHT_DISTANCE_HORIZ
	
	guitar_g.volume_db = -6
	guitar_chord.volume_db = -4

func start() -> void:
	first_key_is_volume_up = not first_key_is_volume_up
	volume = START_VOLUME
	lights[0].turn_on()
	lights[1].turn_on()
	guitar_g.play()

func increase_volume() -> void:
	volume += 1
	if volume == GOAL_VOLUME:
		lights[0].turn_off()
		lights[1].turn_off()
		guitar_chord.play()
		deactivate()
	else:
		play_current_guitar()

func decrease_volume() -> void:
	volume -= 1
	if volume == FAIL_VOLUME:
		fail()
	else:
		play_current_guitar()

func play_current_guitar() -> void:
	guitar_c.volume_db = GUITAR_VOLUME - GUITAR_VOLUME_STEP*(GOAL_VOLUME - volume)
	guitar_c.play()

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
