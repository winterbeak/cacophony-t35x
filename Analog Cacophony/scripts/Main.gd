extends Node2D

onready var cacophony = $Cacophony
onready var audio_instruction = $AudioInstruction

func _ready() -> void:
	randomize()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("space"):
		audio_instruction.visible = false
		cacophony.start()
