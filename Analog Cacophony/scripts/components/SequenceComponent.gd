extends "res://scripts/components/BaseComponent.gd"

var inputs = "poiu"
var current_light = 0

func _ready() -> void:
	lights = [$Light1, $Light2, $Light3, $Light4]

func start() -> void:
	lights[0].turn_on()
	current_light = 0

func on_key_press(key: String) -> void:
	for i in range(len(inputs)):
		if key == inputs[i]:
			if current_light == i:
				next_light()
			else:
				fail()

# Changes the activated light to the next one in sequence.
func next_light() -> void:
	
	# Turn off the current light.
	lights[current_light].turn_off()
	current_light += 1
	
	# If we passed the last light, deactivate the component.
	if current_light == len(lights):
		deactivate()
	# Otherwise, turn on the next light.
	else:
		lights[current_light].turn_on()
