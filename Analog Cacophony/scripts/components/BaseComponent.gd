extends Node2D

const VALID_KEYS: String = "qwertyuiopasdfghjkl;zxcvbnm,./"

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

# Detects input events, and passes the typed key into on_key_press.
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		var typed_event = event as InputEventKey
		var key_typed = PoolByteArray([typed_event.unicode]).get_string_from_utf8()
		if (key_typed in VALID_KEYS) and activated:
			on_key_press(key_typed)
