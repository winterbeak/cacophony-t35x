extends "res://scripts/components/BaseComponent.gd"

var first_key_is_left: bool = false
var first_key_pressed: bool = false

onready var guitar_c = $C
onready var guitar_g = $G
onready var guitar_chord = $Chord
onready var second_note_timer = $SecondNoteTimer
const SECOND_NOTE_TIME = 0.3

func _ready() -> void:
	lights = [$Light1, $Light2]
	lights[1].position.x = Constants.LIGHT_DISTANCE_HORIZ
	
	guitar_c.position = Constants.LIGHT_CENTER
	guitar_g.position = Constants.LIGHT_CENTER + Vector2(Constants.LIGHT_DISTANCE_HORIZ, 0)
	guitar_chord.position = Vector2(Constants.LIGHT_DISTANCE_HORIZ, Constants.LIGHT_CENTER_Y)
	
	guitar_c.volume_db = -8
	guitar_g.volume_db = -8
	guitar_chord.volume_db = -4

func start() -> void:
	first_key_is_left = not first_key_is_left
	lights[0].turn_on()
	lights[1].turn_on()
	if first_key_is_left:
		guitar_g.play()
	else:
		guitar_c.play()
	second_note_timer.start(SECOND_NOTE_TIME)
	first_key_pressed = false

func on_deactivate() -> void:
	lights[0].turn_off()
	lights[1].turn_off()

func on_key_press(key: String) -> void:
	if first_key_is_left:
		if key == lights[0].key and not first_key_pressed:
			guitar_g.play()
			first_key_pressed = true
		elif key == lights[1].key and first_key_pressed:
			guitar_c.play()
			deactivate()
		else:
			fail()
	else:
		if key == lights[1].key and not first_key_pressed:
			guitar_c.play()
			first_key_pressed = true
		elif key == lights[0].key and first_key_pressed:
			guitar_g.play()
			deactivate()
		else:
			fail()

func _on_SecondNoteTimer_timeout():
	if first_key_is_left:
		guitar_c.play()
	else:
		guitar_g.play()
