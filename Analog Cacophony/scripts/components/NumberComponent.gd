extends "res://scripts/components/BaseComponent.gd"

var expected: int = 0
var actual: int = 0

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	lights = [$Light]

func start() -> void:
	lights[0].turn_on()
	expected = rng.randi_range(1, 5)
	actual = 0

func on_key_press(key: String) -> void:
	actual += 1
	if actual == expected:
		lights[0].turn_off()
		deactivate()
