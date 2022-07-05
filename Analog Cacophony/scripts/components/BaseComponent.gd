extends Node2D

# Note that S replaces semicolon and ? replaces /
const VALID_KEYS: String = "qwertyuiopasdfghjklSzxcvbnm,.?"

signal fail
var lights: Array = []
var activated: bool = false

# Component-specific activation code. To be implemented by the subclass.
func start() -> void:
	pass

# Activates the component.
# time: Time, in seconds, before the component automatically fails.
func activate(time: float) -> void:
	activated = true
	start()
	$Timer.start(time)

# Deactivates the component, stopping the failure timer.
func deactivate() -> void:
	activated = false
	$Timer.stop()

# Called when the component automatically fails.
func _on_Timer_timeout() -> void:
	fail()

# Causes the component to fail. Call whenever the player does something incorrect.
func fail() -> void:
	deactivate()
	for light in lights:
		light.turn_red()
	emit_signal("fail")

# Determines what to do with the pressed key.
func on_key_press(key: String) -> void:
	pass

func _process(delta: float) -> void:
	if activated:
		for key in VALID_KEYS:
			if Input.is_action_just_pressed(key):
				on_key_press(key)
