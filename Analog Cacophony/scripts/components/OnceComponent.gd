extends "res://scripts/components/BaseComponent.gd"

func _ready() -> void:
	lights = [$Light]

func start() -> void:
	lights[0].turn_on()

func on_key_press(key: String) -> void:
	lights[0].turn_off()
	deactivate()
