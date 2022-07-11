extends "res://scripts/components/BaseComponent.gd"

# When you activate this component, the amount of "dead time" at the
# start when the player cannot press anything is at most
# BEEP_TIME * 2.

const BEEP_COUNT: int = 3
var current_beep: int = 0
var current_press: int = 0
var sequence: Array = []
onready var phone_sounds: Array = [$Phone1, $Phone2, $Phone3]
const PHONE_VOLUME: int = -14

const BEEP_TIME: float = 0.5
onready var next_beep_timer: Timer = $NextBeepTimer

func _ready() -> void:
	# Lights from left to right
	lights = [$Light1, $Light2, $Light3]
	lights[1].position.x = Constants.LIGHT_DISTANCE_HORIZ
	lights[2].position.x = Constants.LIGHT_DISTANCE_HORIZ * 2
	
	for i in range(len(phone_sounds)):
		phone_sounds[i].volume_db = PHONE_VOLUME
		phone_sounds[i].position.x = i*Constants.LIGHT_DISTANCE_HORIZ + Constants.LIGHT_CENTER_X
		phone_sounds[i].position.y = Constants.LIGHT_CENTER_Y

func start() -> void:
	sequence = [0, 1, 2]
	sequence.shuffle()
	
	current_beep = 0
	current_press = 0
	lights[sequence[0]].turn_on()
	phone_sounds[sequence[0]].play()
	next_beep_timer.start(BEEP_TIME)

func on_key_press(key: String) -> void:
	lights[sequence[current_press]].turn_off()
	if key != lights[sequence[current_press]].key:
		fail()
	else:
		phone_sounds[sequence[current_press]].play()
		current_press += 1
		if current_press == BEEP_COUNT:
			deactivate()

func _on_NextBeepTimer_timeout():
	current_beep += 1
	
	# If the player has solved the component, stop beeping
	if not activated:
		next_beep_timer.stop()
	
	# Stop beeping once all beeps are complete
	elif current_beep == BEEP_COUNT:
		next_beep_timer.stop()
		
		# Player may have half-solved the component before the final flash, so
		# only turn on the unpressed lights
		for i in range(current_press, len(sequence)):
			lights[sequence[i]].turn_on()
	
	# Play the next beep and flash the next light
	else:
		lights[sequence[current_beep - 1]].turn_off()
		lights[sequence[current_beep]].turn_on()
		phone_sounds[sequence[current_beep]].play()
