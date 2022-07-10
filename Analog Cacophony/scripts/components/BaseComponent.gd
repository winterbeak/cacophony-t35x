extends Node2D

# Note that S replaces semicolon and ? replaces /
const VALID_KEYS: String = "qwertyuiopasdfghjklSzxcvbnm,.?"

signal fail
var lights: Array = []
var activated: bool = false
onready var fail_sound = $Fail

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
	on_deactivate()
	activated = false
	$Timer.stop()

# Called when the component automatically fails.
func _on_Timer_timeout() -> void:
	fail()

# Causes the component to fail. Call whenever the player does something incorrect.
func fail() -> void:
	fail_sound.volume_db = -12
	fail_sound.pitch_scale = 0.95 + randf()*0.1
	fail_sound.play()
	on_fail()
	deactivate()
	for light in lights:
		light.flash_red()
	emit_signal("fail")

# Determines what to do with the pressed key.
func on_key_press(key: String) -> void:
	pass

# Overrideable function for things that occur when the component is deactivated
# Note that fail() calls deactivate(), so these also run when the component is failed
func on_deactivate() -> void:
	pass

# Overrideable function for things that occur when the component is failed
func on_fail() -> void:
	pass

# Connects the fail signal to some other object
func connect_fail(target: Object) -> void:
	connect("fail", target, "_on_component_fail")

func _process(delta: float) -> void:
	for light in lights:
		if Input.is_action_just_pressed(light.key):
			# If the component is activated, do something with the key
			if activated:
				on_key_press(light.key)
			
			# Otherwise, fail the component
			else:
				fail()
