extends "res://scripts/components/BaseComponent.gd"

var expected: int = 0
var actual: int = 0

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
onready var number_sounds = [$One, $Two, $Three, $Four, $Five]

func _ready() -> void:
	lights = [$Light]
	
	for sound in number_sounds:
		sound.position.x = Constants.LIGHT_CENTER_X
		sound.position.y = Constants.LIGHT_CENTER_Y

func start() -> void:
	lights[0].turn_on()
	expected = rng.randi_range(1, 5)
	actual = 0
	number_sounds[expected - 1].play()

func on_key_press(key: String) -> void:
	actual += 1
	if actual == expected:
		lights[0].turn_off()
		deactivate()
