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
	lights = [$Light]

	tick_sound.volume_db = TICK_VOLUME
	deactivate_sound.volume_db = DEACTIVATE_VOLUME
	
	tick_sound.position = lights[0].position + Constants.LIGHT_CENTER
	deactivate_sound.position = lights[0].position + Constants.LIGHT_CENTER

func start() -> void:
	current_beep = 0
	lights[0].turn_on()
	next_beep_timer.start(BEEP_TIME)
	
	tick_sound.play()

func on_deactivate() -> void:
	lights[0].turn_off()
	next_beep_timer.stop()

func on_key_press(key: String) -> void:
	if current_beep % 2 == 0:
		deactivate_sound.play()
		deactivate()
	else:
		fail()

func _on_NextBeepTimer_timeout():
	current_beep += 1
	
	tick_sound.play()
	
	if current_beep % 2 == 0:
		lights[0].turn_on()
	else:
		lights[0].turn_off()
