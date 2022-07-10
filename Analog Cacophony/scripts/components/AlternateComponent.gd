extends "res://scripts/components/BaseComponent.gd"

var current_light = 0

onready var drum_sounds = [$Drums1, $Drums2, $Drums3, $Drums4]
onready var activate_sound = $Activate

func _ready() -> void:
	lights = [$Light1, $Light2]
	lights[1].position.x = Constants.LIGHT_DISTANCE_HORIZ
	
	activate_sound.position.x = Constants.LIGHT_DISTANCE_HORIZ
	
	for i in range(len(drum_sounds)):
		drum_sounds[i].position.x = (i%2)*Constants.LIGHT_DISTANCE_HORIZ + Constants.LIGHT_CENTER_X
		drum_sounds[i].position.y = Constants.LIGHT_CENTER_Y

func start() -> void:
	lights[0].turn_on()
	current_light = 0
	
	activate_sound.play()

func on_key_press(key: String) -> void:
	if key != lights[current_light % 2].key:
		fail()
	else:
		drum_sounds[current_light].play()
		
		lights[current_light % 2].turn_off()
		current_light += 1
		if current_light == 4:
			deactivate()
		else:
			lights[current_light % 2].turn_on()
