extends Node2D

onready var cacophony = $Cacophony
onready var audio_instruction = $AudioInstruction

onready var flash_timer = $FlashTimer
var FLASH_TIME: float = 0.25
var FLASH_INTERVAL: float = 0.5
var flash_count: int = 0
var TOTAL_FLASHES: int = 3

onready var flash_transition_timer = $FlashTransitionTimer
var FLASH_TRANSITION_TIME: float = 5.0
onready var fade_timer = $FadeTimer
var FADE_TIME: float = 4.0

onready var purple_background = $PurpleBackground

func _ready() -> void:
	purple_background.color.a = 0.0
	randomize()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("space"):
		audio_instruction.visible = false
		cacophony.start()
	
	if not fade_timer.is_stopped():
		var percentage_done = 1.0 - (fade_timer.time_left / FADE_TIME)
		purple_background.color.a = percentage_done
		cacophony.progress_bar.set_fraction(1.0 - percentage_done)

func _on_Cacophony_win():
	cacophony.flash_grid(FLASH_TIME)
	flash_timer.start()
	flash_count += 1

func _on_FlashTimer_timeout():
	cacophony.flash_grid(FLASH_TIME)
	flash_count += 1
	if flash_count >= 3:
		flash_timer.stop()
		flash_transition_timer.start(FLASH_TRANSITION_TIME)

func _on_FlashTransitionTimer_timeout():
	fade_timer.start(FADE_TIME)

func _on_FadeTimer_timeout():
	purple_background.color.a = 1.0
	cacophony.blind_mode = true
	cacophony.start()
