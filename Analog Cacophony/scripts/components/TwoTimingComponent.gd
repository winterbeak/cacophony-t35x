extends "res://scripts/components/BaseComponent.gd"

var current_beep: int = 0

const BEEP_TIME: float = 0.3
onready var next_beep_timer: Timer = $NextBeepTimer
onready var tick_sound = $Tick
onready var deactivate_sound = $Deactivate
const TICK_VOLUME = -4
const DEACTIVATE_VOLUME = 0

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	# Lights from left to right
	lights = [$Light1, $Light2]
	lights[1].position.x = Constants.LIGHT_DISTANCE_HORIZ
	
	tick_sound.volume_db = TICK_VOLUME
	deactivate_sound.volume_db = DEACTIVATE_VOLUME

func start() -> void:
	current_beep = 0
	lights[0].turn_on()
	lights[1].turn_off()
	next_beep_timer.start(BEEP_TIME)
	
	tick_sound.position = lights[0].position + Constants.LIGHT_CENTER
	tick_sound.play()

func on_deactivate() -> void:
	lights[0].turn_off()
	lights[1].turn_off()
	next_beep_timer.stop()

func on_key_press(key: String) -> void:
	if current_beep % 2 == 0 and key == lights[0].key:
		deactivate_sound.position = lights[0].position + Constants.LIGHT_CENTER
		deactivate_sound.play()
		deactivate()
	elif current_beep % 2 == 1 and key == lights[1].key:
		deactivate_sound.position = lights[1].position + Constants.LIGHT_CENTER
		deactivate_sound.play()
		deactivate()
	else:
		fail()

func _on_NextBeepTimer_timeout():
	current_beep += 1
	
	tick_sound.position = lights[current_beep % 2].position + Constants.LIGHT_CENTER
	tick_sound.play()
	
	if current_beep % 2 == 0:
		lights[0].turn_on()
		lights[1].turn_off()
	else:
		lights[1].turn_on()
		lights[0].turn_off()
