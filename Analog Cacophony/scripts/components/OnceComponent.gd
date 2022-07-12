extends "res://scripts/components/BaseComponent.gd"

onready var activate_sound = $Activate
onready var deactivate_sound = $Deactivate
const ACTIVATE_VOLUME = 1
const DEACTIVATE_VOLUME = -3
onready var activate_sound_fader = $ActivateFader

func _ready() -> void:
	lights = [$Light]
	
	activate_sound.volume_db = ACTIVATE_VOLUME
	deactivate_sound.volume_db = DEACTIVATE_VOLUME
	activate_sound.position = Constants.LIGHT_CENTER
	deactivate_sound.position = Constants.LIGHT_CENTER

func start() -> void:
	lights[0].turn_on()
	
	activate_sound.volume_db = ACTIVATE_VOLUME
	activate_sound.play()

func on_key_press(key: String) -> void:
	activate_sound_fader.interpolate_property(activate_sound, "volume_db", ACTIVATE_VOLUME, -60, 0.05)
	activate_sound_fader.start()
	
	lights[0].turn_off()
	deactivate_sound.play()
	deactivate()
