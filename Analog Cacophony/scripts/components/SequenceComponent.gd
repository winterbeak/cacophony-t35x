extends "res://scripts/components/BaseComponent.gd"

var current_light = 0

onready var fill_player = $FillPlayer
onready var activate_player = $ActivatePlayer

func _ready() -> void:
	# Note that Light1 is the rightmost light, and Light4 is the leftmost for this component
	lights = [$Light1, $Light2, $Light3, $Light4]
	for i in range(len(lights)):
		lights[i].position.x = Constants.LIGHT_DISTANCE_HORIZ * (3 - i)

func start() -> void:
	activate_player.play()
	lights[0].turn_on()
	current_light = 0

func on_key_press(key: String) -> void:
	for i in range(len(lights)):
		if key == lights[i].key:
			if current_light == i:
				next_light()
			else:
				fail()

# Changes the activated light to the next one in sequence.
func next_light() -> void:
	
	fill_player.position.x = Constants.LIGHT_DISTANCE_HORIZ * (3.5 - current_light)
	fill_player.pitch_scale = 0.7 + current_light * 0.12
	fill_player.play()
	
	# Turn off the current light.
	lights[current_light].turn_off()
	current_light += 1
	
	# If we passed the last light, deactivate the component.
	if current_light == len(lights):
		deactivate()
	# Otherwise, turn on the next light.
	else:
		lights[current_light].turn_on()
