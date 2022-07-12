extends "res://scripts/components/BaseComponent.gd"

var pressed: Array = []
onready var sounds: Array = [$C, $E, $G]
onready var activate_sound = $Activate
const SOUND_VOLUME = -4
const ACTIVATE_VOLUME = -1

func _ready() -> void:
	lights = [$Light1, $Light2, $Light3]
	lights[1].position.x = Constants.LIGHT_DISTANCE_HORIZ
	lights[2].position.x = Constants.LIGHT_DISTANCE_HORIZ * 2
	
	for i in range(len(sounds)):
		sounds[i].volume_db = SOUND_VOLUME
		sounds[i].position.x = Constants.LIGHT_DISTANCE_HORIZ*i + Constants.LIGHT_CENTER_X
		sounds[i].position.y = Constants.LIGHT_CENTER_Y
	activate_sound.volume_db = ACTIVATE_VOLUME
	activate_sound.position = lights[1].position + Constants.LIGHT_CENTER

func start() -> void:
	activate_sound.play()
	pressed = [false, false, false]
	lights[0].turn_on()
	lights[2].turn_on()

func on_key_press(key: String) -> void:
	
	for i in range(len(lights)):
		if key == lights[i].key:
			if (not pressed[0] or not pressed[2]) and i == 1:
				for light in lights:
					light.turn_off()
				fail()
			else:
				lights[i].turn_off()
				sounds[i].play()
				pressed[i] = true
				
				if pressed[0] and pressed[2]:
					lights[1].turn_on()
	
	# Deactivate if everything is pressed
	for press in pressed:
		if not press:
			return
	
	for light in lights:
		light.turn_off()
	deactivate()
