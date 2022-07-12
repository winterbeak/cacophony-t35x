extends "res://scripts/components/BaseComponent.gd"

# When you activate this component, the amount of "dead time" at the
# start when the player cannot press anything is at most
# BEEP_TIME * 5.

var beep_count: int = 0
var current_beep: int = 1

const BEEP_TIME: float = 0.2
onready var next_beep_timer: Timer = $NextBeepTimer
onready var tick_sound = $Tick
onready var deactivate_sound = $Deactivate
const TICK_VOLUME = -4
const DEACTIVATE_VOLUME = -2

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	# Lights from left to right
	lights = [$Light1, $Light2]
	lights[1].position.x = Constants.LIGHT_DISTANCE_HORIZ
	
	tick_sound.volume_db = TICK_VOLUME
	deactivate_sound.volume_db = DEACTIVATE_VOLUME

func start() -> void:
	beep_count = rng.randi_range(3, 6)
	current_beep = 1
	lights[0].turn_on()
	lights[1].turn_off()
	next_beep_timer.start(BEEP_TIME)
	tick_sound.play()

func on_key_press(key: String) -> void:
	if next_beep_timer.is_stopped():
		lights[0].turn_off()
		lights[1].turn_off()
		if beep_count % 2 == 0 and key == lights[1].key:
			deactivate_sound.play()
			deactivate()
		elif beep_count % 2 == 1 and key == lights[0].key:
			deactivate_sound.play()
			deactivate()
		else:
			fail()

func _on_NextBeepTimer_timeout():
	current_beep += 1
	if current_beep == beep_count:
		next_beep_timer.stop()
		lights[0].turn_on()
		lights[1].turn_on()
	elif current_beep % 2 == 0:
		lights[0].turn_off()
		lights[1].turn_on()
		tick_sound.play()
	else:
		lights[0].turn_on()
		lights[1].turn_off()
		tick_sound.play()
