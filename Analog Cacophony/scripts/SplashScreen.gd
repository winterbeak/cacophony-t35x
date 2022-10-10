extends Node2D

signal done

onready var fade_in = $FadeIn
onready var hold_timer = $HoldTimer
onready var fade_out = $FadeOut
const FADE_IN_TIME: float = 1.5
const HOLD_TIME: float = 3.0
const FADE_OUT_TIME: float = 1.5

onready var animation = $Logo/Animation
onready var text = $Logo/Text
onready var logo = $Logo

onready var jingle = $Jingle
var frame: int = 0

const LOGO_NAME_GAP: float = 6.0
const SCALE: float = 4.0

func _ready():
	animation.scale = Vector2(SCALE, SCALE)
	text.scale = Vector2(SCALE, SCALE)
	
	var animation_size: Vector2 = animation.get_sprite_frames().get_frame("default", 0).get_size()
	var screen_size: Vector2 = get_viewport_rect().size
	
	var logo_width: float = (text.texture.get_width() + LOGO_NAME_GAP + animation_size.x)*SCALE
	var logo_height: float = (animation_size.y + 1)*SCALE

	animation.position.x = screen_size.x / 2 - logo_width / 2
	animation.position.y = screen_size.y / 2 - logo_height / 2
	
	text.position.x = animation.position.x + (animation_size.x + LOGO_NAME_GAP)*SCALE
	text.position.y = animation.position.y - 3*SCALE
	
	fade_in.interpolate_property(logo, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), FADE_IN_TIME)
	fade_out.interpolate_property(logo, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), FADE_OUT_TIME)
	
	fade_in.start()
	jingle.volume_db = -2

func _input(event):
	if event is InputEventKey and event.pressed:
		fade_in.stop_all()
		hold_timer.stop()
		fade_out.stop_all()
		logo.modulate.a = 0
		jingle.stop()
		emit_signal("done")

func _on_FadeIn_tween_completed(object, key):
	hold_timer.start(HOLD_TIME)

func _on_HoldTimer_timeout():
	fade_out.start()

func _on_FadeOut_tween_completed(object, key):
	emit_signal("done")

func _process(delta):
	if frame < 10:
		frame += 1
		
		if frame == 10:
			jingle.play()
