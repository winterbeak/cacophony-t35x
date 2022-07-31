extends "res://scripts/components/BaseComponent.gd"

var pitch: int = 0
const START_PITCH: int = 4
const GOAL_PITCH: int = 0
var first_key_is_pitch_up: bool = true

onready var guitar_scale = [$D, $E, $F, $G, $GSharp, $A]
onready var guitar_chord = $Chord
const GUITAR_VOLUME_STEP = 4
const GUITAR_VOLUME = -2

func _ready() -> void:
	lights = [$Light1, $Light2]
	lights[1].position.x = Constants.LIGHT_DISTANCE_HORIZ
	
	for note in guitar_scale:
		note.position = Vector2(Constants.LIGHT_DISTANCE_HORIZ, Constants.LIGHT_CENTER_Y)
		note.volume_db = -8
	guitar_chord.position = Vector2(Constants.LIGHT_DISTANCE_HORIZ, Constants.LIGHT_CENTER_Y)
	guitar_chord.volume_db = -4

func start() -> void:
	first_key_is_pitch_up = not first_key_is_pitch_up
	pitch = START_PITCH
	lights[0].turn_on()
	lights[1].turn_on()
	play_current_guitar()

func increase_pitch() -> void:
	if pitch < len(guitar_scale):
		pitch += 1
	play_current_guitar()

func decrease_pitch() -> void:
	pitch -= 1
	if pitch == GOAL_PITCH:
		guitar_chord.play()
		lights[0].turn_off()
		lights[1].turn_off()
		deactivate()
	else:
		play_current_guitar()

func play_current_guitar() -> void:
	guitar_scale[pitch - 1].play()

func on_key_press(key: String) -> void:
	if key == lights[0].key:
		if first_key_is_pitch_up:
			increase_pitch()
		else:
			decrease_pitch()
	elif key == lights[1].key:
		if not first_key_is_pitch_up:
			increase_pitch()
		else:
			decrease_pitch()
