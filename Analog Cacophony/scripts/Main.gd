extends Node2D

onready var cacophony = $Cacophony
onready var audio_instruction = $AudioInstruction
onready var audio_instruction_label = $AudioInstruction/Label
onready var audio_instruction_fade_in = $AudioInstructionFadeIn
onready var audio_instruction_fade_out = $AudioInstructionFadeOut
var audio_instruction_dismissed: bool = false

onready var final_fade_out = $FinalFadeOut
onready var credits_fade_in = $CreditsFadeIn

onready var flash_timer = $FlashTimer
var FLASH_TIME: float = 0.165
var LAST_FLASH_TIME: float = 1.0
var FLASH_INTERVAL: float = 0.203
var flash_count: int = 0
var TOTAL_FLASHES: int = 3

onready var flash_transition_timer = $FlashTransitionTimer
var FLASH_TRANSITION_TIME: float = 3.5
onready var blind_fade_timer = $FadeTimer
var FADE_TIME: float = 4.565
onready var post_fade_timer = $PostFadeTimer
var POST_FADE_TIME: float = 3.5

onready var purple_background = $PurpleBackground

onready var win_sound = $WinSound
onready var drain_sound = $DrainSound

onready var credits = $Credits

var splash_done: bool = false
var frame_after_splash: bool = false

func _ready() -> void:
	purple_background.color.a = 0.0
	win_sound.volume_db = -7
	drain_sound.volume_db = -4
	
	audio_instruction_label.modulate.a = 0
	audio_instruction_fade_in.interpolate_property(audio_instruction_label, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 1.5)
	audio_instruction_fade_out.interpolate_property(audio_instruction, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.2)
	
	final_fade_out.interpolate_property(cacophony, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1.5)
	credits_fade_in.interpolate_property(credits, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 1.5)
	
	randomize()

func _process(delta: float) -> void:
	if not audio_instruction_dismissed and frame_after_splash and Input.is_action_just_pressed("space"):
		audio_instruction_dismissed = true
		audio_instruction_fade_out.start()
		cacophony.start()
	
	# Avoid consuming the same spacebar input if space is used to skip the splash screen
	if splash_done:
		frame_after_splash = true
	
	if not blind_fade_timer.is_stopped():
		var percentage_done = 1.0 - (blind_fade_timer.time_left / FADE_TIME)
		purple_background.color.a = percentage_done
		cacophony.progress_bar.set_fraction(1.0 - percentage_done)

func _on_Cacophony_win():
	cacophony.flash_grid(FLASH_TIME)
	flash_timer.start(FLASH_INTERVAL)
	flash_count += 1
	win_sound.play()

func _on_FlashTimer_timeout():
	
	flash_count += 1
	if flash_count >= 3:
		cacophony.flash_grid(LAST_FLASH_TIME)
		flash_count = 0
		flash_timer.stop()
		flash_transition_timer.start(FLASH_TRANSITION_TIME)
	else:
		cacophony.flash_grid(FLASH_TIME)

func _on_FlashTransitionTimer_timeout():
	if not cacophony.blind_mode:
		blind_fade_timer.start(FADE_TIME)
		drain_sound.play()
	else:
		final_fade_out.start()

func _on_FadeTimer_timeout():
	post_fade_timer.start(POST_FADE_TIME)
	cacophony.progress_bar.set_fraction(0.0)

func _on_PostFadeTimer_timeout():
	purple_background.color.a = 1.0
	cacophony.blind_mode = true
	cacophony.start()

func _on_SplashScreen_done():
	splash_done = true
	audio_instruction_fade_in.start()

func _on_FinalFadeOut_tween_completed(object, key):
	credits_fade_in.start()
