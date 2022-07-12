extends Node2D

# Note that S replaces semicolon and ? replaces /
const VALID_KEYS: String = "qwertyuiopasdfghjklSzxcvbnm,.?"

signal fail
var lights: Array = []
var activated: bool = false
var locked: bool = false
onready var fail_sound = $Fail
onready var timer = $Timer

# Component-specific activation code. To be implemented by the subclass.
func start() -> void:
	pass

# Activates the component.
# time: Time, in seconds, before the component automatically fails.
func activate(time: float) -> void:
	if not locked:
		activated = true
		start()
		timer.start(time)

# Deactivates the component, stopping the failure timer.
func deactivate() -> void:
	on_deactivate()
	activated = false
	timer.stop()

# Locks the component, deactivating it and making it not fail on keypress.
func lock() -> void:
	locked = true
	deactivate()
	for light in lights:
		light.turn_off()

# Unlocks the component, making it fail on keypress again.
func unlock() -> void:
	locked = false

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
	if not locked:
		for light in lights:
			if Input.is_action_just_pressed(light.key):
				# If the component is activated, do something with the key
				if activated:
					
					# Leeway to push the game in the player's favor; each correct press below 0.5
					# seconds left will set the timer back to 0.5 so that the player won't be failed
					# in the middle of inputting the solution
					if timer.time_left < 0.5:
						timer.start(0.5)
					
					on_key_press(light.key)
				
				# Otherwise, fail the component
				else:
					fail()
