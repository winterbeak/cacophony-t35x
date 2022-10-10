extends "res://scripts/components/BaseComponent.gd"

const HOLD_TIME: float = 4.65
onready var hold_timer = $HoldTimer
onready var laser_sound = $Laser
onready var buildup_sound = $Buildup
onready var hold_voice = $Hold
onready var release_voice = $Release
const LASER_VOLUME = 0
const BUILDUP_VOLUME = 0
const HOLD_VOICE_VOLUME = 0
const RELEASE_VOICE_VOLUME = 0

onready var buildup_fadeout = $BuildupFadeout

func _ready() -> void:
	lights = [$Light]
	
	laser_sound.position = Constants.LIGHT_CENTER
	laser_sound.volume_db = LASER_VOLUME
	buildup_sound.position = Constants.LIGHT_CENTER
	hold_voice.position = Constants.LIGHT_CENTER
	hold_voice.volume_db = HOLD_VOICE_VOLUME
	release_voice.position = Constants.LIGHT_CENTER
	release_voice.volume_db = RELEASE_VOICE_VOLUME
	
func start() -> void:
	lights[0].turn_on()
	hold_voice.play()

func on_deactivate() -> void:
	lights[0].turn_off()
	hold_timer.stop()
	
	# Fade out the buildup sound
	buildup_fadeout.interpolate_property(buildup_sound, "volume_db", BUILDUP_VOLUME, -60, 0.05)
	buildup_fadeout.start()

func on_key_press(key: String) -> void:
	hold_timer.start(HOLD_TIME)
	timer.start(HOLD_TIME + 2.0)
	
	buildup_sound.volume_db = BUILDUP_VOLUME
	buildup_sound.play()

func on_key_release(key: String) -> void:
	if hold_timer.is_stopped():
		laser_sound.play()
		deactivate()
	else:
		fail()

func _on_HoldTimer_timeout():
	release_voice.play()
