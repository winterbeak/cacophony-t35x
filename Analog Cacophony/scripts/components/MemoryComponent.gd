extends "res://scripts/components/BaseComponent.gd"

# When you activate this component, the amount of "dead time" at the
# start when the player cannot press anything is at most
# BEEP_TIME * 2.

const BEEP_COUNT: int = 3
var current_beep: int = 0
var current_press: int = 0
var sequence: Array = []

const BEEP_TIME: float = 0.5
onready var next_beep_timer: Timer = $NextBeepTimer

func _ready() -> void:
	# Lights from left to right
	lights = [$Light1, $Light2, $Light3]
	lights[1].position.x = Constants.LIGHT_DISTANCE_HORIZ
	lights[2].position.x = Constants.LIGHT_DISTANCE_HORIZ * 2

func start() -> void:
	sequence = [0, 1, 2]
	sequence.shuffle()
	
	current_beep = 0
	current_press = 0
	lights[sequence[0]].turn_on()
	next_beep_timer.start(BEEP_TIME)

func on_key_press(key: String) -> void:
	lights[sequence[current_press]].turn_off()
	if key != lights[sequence[current_press]].key:
		fail()
	elif current_press == BEEP_COUNT - 1:
		deactivate()
	else:
		current_press += 1

func _on_NextBeepTimer_timeout():
	current_beep += 1
	if current_beep == BEEP_COUNT:
		next_beep_timer.stop()
		lights[0].turn_on()
		lights[1].turn_on()
		lights[2].turn_on()
	else:
		lights[sequence[current_beep - 1]].turn_off()
		lights[sequence[current_beep]].turn_on()
