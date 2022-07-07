extends "res://scripts/components/BaseComponent.gd"

# When you activate this component, the amount of "dead time" at the
# start when the player cannot press anything is at most
# BEEP_TIME * 4.

var expected: int = 0
var actual: int = 0

var beep_count: int = 0
const BEEP_TIME: float = 0.4
onready var next_beep_timer: Timer = $NextBeepTimer

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	lights = [$Light]

func start() -> void:
	lights[0].turn_on()
	expected = rng.randi_range(1, 5)
	actual = 0
	beep_count = 1
	next_beep_timer.start(BEEP_TIME)

func on_key_press(key: String) -> void:
	actual += 1
	if actual == expected:
		lights[0].turn_off()
		deactivate()

func _on_NextBeepTimer_timeout():
	beep_count += 1
	if beep_count == expected:
		next_beep_timer.stop()
